-- Java (Eclipse JDT Language Server)

local workspaceEnvFolder = os.getenv("WORKSPACE_ENV") or (os.getenv("HOME") .. "/Workspace/env")

local cached_runtimes = nil
local function get_java_runtimes()
  if cached_runtimes ~= nil then
    return cached_runtimes
  end
  cached_runtimes = {}
  local javaHome = os.getenv("JAVA_HOME")
  if javaHome then
    local res = vim.system({ "java", "-version" }, { text = true }):wait()
    local out = (res.stderr or "") .. (res.stdout or "")
    local javaVersion = out:match('version "(%d+)')
    if javaVersion then
      cached_runtimes = {
        {
          name = "JavaSE-" .. javaVersion,
          path = javaHome,
        },
      }
    end
  end
  return cached_runtimes
end

return {
  cmd = function(dispatchers, config)
    local root_dir = (config and config.root_dir) or vim.fn.getcwd()
    local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
    local launcher = vim.fn.glob(workspaceEnvFolder .. "/jdtls/latest/plugins/org.eclipse.equinox.launcher_*.jar")
    local cmd = {
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
      "-jar",
      launcher,
      "-configuration",
      workspaceEnvFolder .. "/jdtls/latest/config_linux",
      "-data",
      workspaceEnvFolder .. "/jdtls/workspaces/" .. project_name,
    }
    return vim.lsp.rpc.start(cmd, dispatchers, {
      cwd = config and config.cmd_cwd or nil,
      env = config and config.cmd_env or nil,
      detached = config and config.detached or nil,
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
    vim.keymap.set("n", "<leader>jo", function()
      local ok, jdtls = pcall(require, "jdtls")
      if ok then
        jdtls.organize_imports()
      else
        vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" }, diagnostics = {} }, apply = true })
      end
    end, opts)

    local ok, jdtls = pcall(require, "jdtls")
    if ok then
      vim.keymap.set("n", "<leader>jv", function() jdtls.extract_variable() end, opts)
      vim.keymap.set("v", "<leader>jv", function() jdtls.extract_variable(true) end, opts)
      vim.keymap.set("n", "<leader>jc", function() jdtls.extract_constant() end, opts)
      vim.keymap.set("v", "<leader>jc", function() jdtls.extract_constant(true) end, opts)
      vim.keymap.set("v", "<leader>jm", function() jdtls.extract_method(true) end, opts)
      vim.keymap.set("n", "<leader>ju", function() jdtls.update_project_config() end, opts)
      vim.keymap.set("n", "<leader>jt", function() jdtls.test_class() end, opts)
      vim.keymap.set("n", "<leader>jn", function() jdtls.test_nearest_method() end, opts)
    end
  end,
}
