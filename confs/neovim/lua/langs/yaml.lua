-- YAML (yaml-language-server). Formatted by bun fmt.

return {
  lsp = {
    yamlls = {
      settings = {
        redhat = {
          telemetry = {
            enabled = false,
          },
        },
        yaml = {
          validate = true,
          -- yaml-language-server formats with a bundled prettier; formatting stays with the project.
          format = {
            enable = false,
          },
          schemaStore = {
            enable = true,
            url = "https://www.schemastore.org/api/json/catalog.json",
          },
          schemas = {
            kubernetes = {
              "k8s/**/*.{yml,yaml}",
              "manifests/**/*.{yml,yaml}",
              "apps/*/manifests/**/*.{yml,yaml}",
              "*.k8s.{yml,yaml}",
            },
          },
        },
      },
    },
  },
  formatters = {
    yaml = { "bun_fmt" },
  },
  parsers = { "yaml" },
}
