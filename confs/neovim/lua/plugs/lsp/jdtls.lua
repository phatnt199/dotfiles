-- Java (Eclipse JDT Language Server)

local workspaceEnvFolder = os.getenv("WORKSPACE_ENV")
if workspaceEnvFolder == nil then
  workspaceEnvFolder = os.getenv("HOME") .. "/Workspace/env"
end

-- Resolve the active Java home and version dynamically.
local javaHome = os.getenv("JAVA_HOME")
local javaVersion = nil
if javaHome then
  local handle = io.popen("java -version 2>&1")
  if handle then
    local result = handle:read("*a")
    handle:close()
    javaVersion = result:match('version "(%d+)')
  end
end

return {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "-Xmx2g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    vim.fn.glob(workspaceEnvFolder .. "/jdtls/latest/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration",
    workspaceEnvFolder .. "/jdtls/latest/config_linux",
    "-data",
    workspaceEnvFolder .. "/jdtls/workspaces/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
  },
  root_dir = vim.fs.dirname(vim.fs.find({
    "build.xml",
    "pom.xml",
    ".gradlew",
    ".gitignore",
    "mvnw",
    "build.gradle",
    "build.gradle.kts",
    "settings.gradle",
    "settings.gradle.kts",
  }, { upward = true })[1]),
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
        runtimes = javaHome and javaVersion and {
          {
            name = "JavaSE-" .. javaVersion,
            path = javaHome,
          },
        } or {},
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
    -- Java-specific keybindings
    local opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set("n", "<leader>jo", "<Cmd>lua require('jdtls').organize_imports()<CR>", opts)
    vim.keymap.set("n", "<leader>jv", "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
    vim.keymap.set("v", "<leader>jv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
    vim.keymap.set("n", "<leader>jc", "<Cmd>lua require('jdtls').extract_constant()<CR>", opts)
    vim.keymap.set("v", "<leader>jc", "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", opts)
    vim.keymap.set("v", "<leader>jm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)
    vim.keymap.set("n", "<leader>ju", "<Cmd>lua require('jdtls').update_project_config()<CR>", opts)
    vim.keymap.set("n", "<leader>jt", "<Cmd>lua require('jdtls').test_class()<CR>", opts)
    vim.keymap.set("n", "<leader>jn", "<Cmd>lua require('jdtls').test_nearest_method()<CR>", opts)
  end,
}
