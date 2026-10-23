-- Java (Eclipse JDT Language Server)

local workspaceEnvFolder = os.getenv("WORKSPACE_ENV") or (os.getenv("HOME") .. "/Workspace/env")

local function java_version()
  local res = vim.system({ "java", "-version" }, { text = true }):wait()
  return ((res.stderr or "") .. (res.stdout or "")):match('version "(%d+)')
end

local cached_runtimes
local function get_java_runtimes()
  if cached_runtimes then
    return cached_runtimes
  end
  local java_home = os.getenv("JAVA_HOME")
  local version = java_home and java_version()
  cached_runtimes = version and { { name = "JavaSE-" .. version, path = java_home } } or {}
  return cached_runtimes
end

local JVM_ARGS = {
  "java",
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.level=ERROR",
  "-Xms1g",
  "-Xmx2g",
  "--add-modules=ALL-SYSTEM",
  "--add-opens",
  "java.base/java.util=ALL-UNNAMED",
  "--add-opens",
  "java.base/java.lang=ALL-UNNAMED",
}

-- { mode, lhs, jdtls method, visual-selection flag }; bound only when the jdtls plugin is present.
local JDTLS_KEYMAPS = {
  { "n", "<leader>jv", "extract_variable" },
  { "v", "<leader>jv", "extract_variable", true },
  { "n", "<leader>jc", "extract_constant" },
  { "v", "<leader>jc", "extract_constant", true },
  { "v", "<leader>jm", "extract_method", true },
  { "n", "<leader>ju", "update_project_config" },
  { "n", "<leader>jt", "test_class" },
  { "n", "<leader>jn", "test_nearest_method" },
}

local function organize_imports()
  local ok, jdtls = pcall(require, "jdtls")
  if ok then
    return jdtls.organize_imports()
  end
  vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" }, diagnostics = {} }, apply = true })
end

return {
  cmd = function(dispatchers, config)
    config = config or {}
    local root_dir = config.root_dir or vim.fn.getcwd()
    local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
    local launcher = vim.fn.glob(workspaceEnvFolder .. "/jdtls/latest/plugins/org.eclipse.equinox.launcher_*.jar")
    local cmd = vim.list_extend(vim.deepcopy(JVM_ARGS), {
      "-jar",
      launcher,
      "-configuration",
      workspaceEnvFolder .. "/jdtls/latest/config_linux",
      "-data",
      workspaceEnvFolder .. "/jdtls/workspaces/" .. project_name,
    })
    return vim.lsp.rpc.start(cmd, dispatchers, {
      cwd = config.cmd_cwd,
      env = config.cmd_env,
      detached = config.detached,
    })
  end,
  before_init = function(_, config)
    config.settings = config.settings or {}
    config.settings.java = config.settings.java or {}
    config.settings.java.configuration = {
      runtimes = get_java_runtimes(),
    }
  end,
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      maven = {
        downloadSources = true,
      },
      imports = {
        gradle = {
          wrapper = {
            checksums = {
              {
                sha256 = "423cb469ccc0ecc31f0e4e1c309976198ccb734cdcbb7029d4bda0f18f57e8d9",
                allowed = true,
              },
            },
          },
        },
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      format = {
        enabled = true,
        settings = {
          url = vim.fn.stdpath("config") .. "/lang-servers/intellij-java-google-style.xml",
          profile = "GoogleStyle",
        },
      },
      signatureHelp = {
        enabled = true,
      },
      contentProvider = {
        preferred = "fernflower",
      },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
        importOrder = {
          "java",
          "javax",
          "com",
          "org",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
      configuration = {
        runtimes = {},
      },
    },
  },
  init_options = {
    bundles = {},
    extendedClientCapabilities = {
      progressReportProvider = true,
      classFileContentsSupport = true,
      generateToStringPromptSupport = true,
      hashCodeEqualsPromptSupport = true,
      advancedExtractRefactoringSupport = true,
      advancedOrganizeImportsSupport = true,
      generateConstructorsPromptSupport = true,
      generateDelegateMethodsPromptSupport = true,
      moveRefactoringSupport = true,
      overrideMethodsPromptSupport = true,
      inferSelectionSupport = { "extractMethod", "extractVariable", "extractConstant" },
    },
  },
  on_attach = function(_, bufnr)
    local opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set("n", "<leader>jo", organize_imports, opts)

    local ok, jdtls = pcall(require, "jdtls")
    if not ok then
      return
    end
    for _, keymap in ipairs(JDTLS_KEYMAPS) do
      local mode, lhs, method, visual = unpack(keymap)
      vim.keymap.set(mode, lhs, function() jdtls[method](visual) end, opts)
    end
  end,
}
