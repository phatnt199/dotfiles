local module = {}

function module.merge_tables(t1, t2)
  local result = {}

  for k, v in pairs(t1) do
    result[k] = v
  end

  for k, v in pairs(t2) do
    result[k] = v
  end

  return result
end

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
  if vim.fn.executable(bin_name) == 1 then
    return vim.fn.exepath(bin_name)
  end
  return nil
end

local function cycle_files(files, current, step, label)
  if #files == 0 then
    vim.notify(string.format("No %s files found", label), vim.log.levels.INFO)
    return
  end

  local idx = nil
  for i, f in ipairs(files) do
    if f == current then
      idx = i
      break
    end
  end

  local target_idx
  if idx then
    target_idx = ((idx - 1 + step) % #files) + 1
  elseif step > 0 then
    target_idx = 1
    for i, f in ipairs(files) do
      if f > current then
        target_idx = i
        break
      end
    end
  else
    target_idx = #files
    for i = #files, 1, -1 do
      if files[i] < current then
        target_idx = i
        break
      end
    end
  end

  local target = files[target_idx]
  if target ~= current then
    vim.cmd.edit(vim.fn.fnameescape(target))
  end
  local rel = vim.fn.fnamemodify(target, ":.")
  vim.api.nvim_echo({ { string.format("[%s %d/%d] %s", label, target_idx, #files, rel), "ModeMsg" } }, false, {})
end

local function collect_tree_files(node, out)
  if not node or not node.nodes then
    return
  end
  for _, child in ipairs(node.nodes) do
    if not child.hidden then
      if child.nodes ~= nil then
        if child.open then
          collect_tree_files(child, out)
        end
      elseif child.absolute_path then
        table.insert(out, vim.fs.normalize(child.absolute_path))
      end
    end
  end
end

local function ensure_editor_win()
  local ok, api = pcall(require, "nvim-tree.api")
  if ok and api.tree.is_tree_buf(0) then
    vim.cmd.wincmd("p")
  end
  return ok, api
end

function module.nav_tree_file(step)
  local ok, api = ensure_editor_win()
  local current = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
  local files = {}

  if ok and api.tree.get_nodes() then
    pcall(api.tree.find_file, { buf = vim.api.nvim_get_current_buf(), open = false, focus = false })
    collect_tree_files(api.tree.get_nodes(), files)
  end
  -- Fallback to sibling files in the current file's directory when nvim-tree hasn't been opened
  -- or when the current buffer lies outside the active tree root.
  local in_tree = false
  for _, f in ipairs(files) do
    if f == current then
      in_tree = true
      break
    end
  end

  if not in_tree then
    files = {}
    local dir = current ~= "" and vim.fs.dirname(current) or vim.fn.getcwd()
    for name, ftype in vim.fs.dir(dir) do
      if ftype == "file" or ftype == "link" then
        table.insert(files, vim.fs.normalize(vim.fs.joinpath(dir, name)))
      end
    end
    table.sort(files)
  end

  cycle_files(files, current, step, "tree")
end

function module.nav_git_file(step)
  ensure_editor_win()
  local current = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
  local start_path = current ~= "" and current or vim.fn.getcwd()
  local git_root = vim.fs.root(start_path, ".git")
  if not git_root then
    vim.notify("Not inside a git repository", vim.log.levels.WARN)
    return
  end

  local seen = {}
  local files = {}
  local function add_lines(cmd)
    local res = vim.system(cmd, { cwd = git_root, text = true }):wait()
    if res.code == 0 and res.stdout then
      for line in res.stdout:gmatch("[^\r\n]+") do
        if line ~= "" and not seen[line] then
          local abs = vim.fs.normalize(vim.fs.joinpath(git_root, line))
          if vim.uv.fs_stat(abs) then
            seen[line] = true
            table.insert(files, abs)
          end
        end
      end
    end
  end

  add_lines({ "git", "diff", "--name-only", "--diff-filter=ACMRTXB", "HEAD" })
  add_lines({ "git", "diff", "--name-only", "--diff-filter=ACMRTXB", "--cached" })
  add_lines({ "git", "diff", "--name-only", "--diff-filter=ACMRTXB" })
  add_lines({ "git", "ls-files", "--others", "--exclude-standard" })
  table.sort(files)

  cycle_files(files, current, step, "git")
end

return module;
