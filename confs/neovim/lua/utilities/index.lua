local module = {}

-- The nearest project root, from `path` upward, whose `.configs/` folder holds `file`
-- (e.g. "oxlint.config.mts"). Tools never look inside `.configs/` on their own.
function module.dot_configs_root(path, file)
  return vim.fs.root(path, function(name, dir)
    return name == ".configs" and vim.uv.fs_stat(vim.fs.joinpath(dir, ".configs", file)) ~= nil
  end)
end

-- Walk upward from `path` to find the nearest `node_modules/.bin/<bin_name>` executable
-- (handles both package-local binaries and monorepo-hoisted binaries), falling back to `$PATH`.
function module.find_node_bin(path, bin_name)
  local rel = vim.fs.joinpath("node_modules", ".bin", bin_name)
  local root = vim.fs.root(path, function(name, dir)
    return name == "node_modules" and vim.fn.executable(vim.fs.joinpath(dir, rel)) == 1
  end)
  if root then
    return vim.fs.joinpath(root, rel)
  end
  return vim.fn.executable(bin_name) == 1 and vim.fn.exepath(bin_name) or nil
end

local function current_file()
  return vim.fs.normalize(vim.api.nvim_buf_get_name(0))
end

-- First index (scanning backwards when `reverse`) whose file satisfies `pred`.
local function index_of(files, pred, reverse)
  local first, last, by = 1, #files, 1
  if reverse then
    first, last, by = #files, 1, -1
  end
  for i = first, last, by do
    if pred(files[i]) then
      return i
    end
  end
end

-- Index to jump to from `current`, wrapping around the list. A `current` that is not in the list
-- lands on its nearest neighbour in sort order.
local function target_index(files, current, step)
  local idx = index_of(files, function(f) return f == current end)
  if idx then
    return (idx - 1 + step) % #files + 1
  end
  if step > 0 then
    return index_of(files, function(f) return f > current end) or 1
  end
  return index_of(files, function(f) return f < current end, true) or #files
end

local function cycle_files(files, current, step, label)
  if #files == 0 then
    vim.notify(string.format("No %s files found", label), vim.log.levels.INFO)
    return
  end

  local idx = target_index(files, current, step)
  local target = files[idx]
  if target ~= current then
    vim.cmd.edit(vim.fn.fnameescape(target))
  end
  local rel = vim.fn.fnamemodify(target, ":.")
  vim.api.nvim_echo({ { string.format("[%s %d/%d] %s", label, idx, #files, rel), "ModeMsg" } }, false, {})
end

local collect_tree_files

local function collect_tree_node(node, out)
  if node.hidden then
    return
  end
  if node.nodes then
    if node.open then
      collect_tree_files(node, out)
    end
    return
  end
  if node.absolute_path then
    table.insert(out, vim.fs.normalize(node.absolute_path))
  end
end

-- Files of the expanded, visible part of an nvim-tree node, in tree order.
function collect_tree_files(node, out)
  for _, child in ipairs(node and node.nodes or {}) do
    collect_tree_node(child, out)
  end
end

-- nvim-tree's api when the cursor is in an editor window; steps out of the tree window first.
local function editor_win_tree_api()
  local ok, api = pcall(require, "nvim-tree.api")
  if ok and api.tree.is_tree_buf(0) then
    vim.cmd.wincmd("p")
  end
  return ok and api or nil
end

local function tree_files(api)
  local files = {}
  if api and api.tree.get_nodes() then
    pcall(api.tree.find_file, { buf = vim.api.nvim_get_current_buf(), open = false, focus = false })
    collect_tree_files(api.tree.get_nodes(), files)
  end
  return files
end

-- Fallback for when nvim-tree hasn't been opened, or the buffer lies outside the active tree root.
local function sibling_files(current)
  local dir = current ~= "" and vim.fs.dirname(current) or vim.fn.getcwd()
  local files = {}
  for name, ftype in vim.fs.dir(dir) do
    if ftype == "file" or ftype == "link" then
      table.insert(files, vim.fs.normalize(vim.fs.joinpath(dir, name)))
    end
  end
  table.sort(files)
  return files
end

function module.nav_tree_file(step)
  local api = editor_win_tree_api()
  local current = current_file()
  local files = tree_files(api)

  if not vim.list_contains(files, current) then
    files = sibling_files(current)
  end

  cycle_files(files, current, step, "tree")
end

local GIT_FILE_COMMANDS = {
  { "git", "diff", "--name-only", "--diff-filter=ACMRTXB", "HEAD" },
  { "git", "diff", "--name-only", "--diff-filter=ACMRTXB", "--cached" },
  { "git", "diff", "--name-only", "--diff-filter=ACMRTXB" },
  { "git", "ls-files", "--others", "--exclude-standard" },
}

local function git_lines(cmd, cwd)
  local res = vim.system(cmd, { cwd = cwd, text = true }):wait()
  if res.code ~= 0 or not res.stdout then
    return {}
  end
  return vim.split(res.stdout, "[\r\n]+", { trimempty = true })
end

local function unique(list)
  local seen = {}
  return vim.tbl_filter(function(item)
    local first = not seen[item]
    seen[item] = true
    return first
  end, list)
end

-- Changed (staged, unstaged, vs HEAD) and untracked files of the repo, sorted and still on disk.
local function git_changed_files(root)
  local files = vim
    .iter(GIT_FILE_COMMANDS)
    :map(function(cmd) return git_lines(cmd, root) end)
    :flatten()
    :map(function(line) return vim.fs.normalize(vim.fs.joinpath(root, line)) end)
    :filter(function(abs) return vim.uv.fs_stat(abs) ~= nil end)
    :totable()

  files = unique(files)
  table.sort(files)
  return files
end

function module.nav_git_file(step)
  editor_win_tree_api()
  local current = current_file()
  local git_root = vim.fs.root(current ~= "" and current or vim.fn.getcwd(), ".git")
  if not git_root then
    vim.notify("Not inside a git repository", vim.log.levels.WARN)
    return
  end

  cycle_files(git_changed_files(git_root), current, step, "git")
end

return module
