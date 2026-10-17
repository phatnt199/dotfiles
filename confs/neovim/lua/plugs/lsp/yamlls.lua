-- YAML (yaml-language-server)
return {
  settings = {
    redhat = {
      telemetry = {
        enabled = false,
      },
    },
    yaml = {
      validate = true,
      format = {
        enable = true,
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
}
