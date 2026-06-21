-- YAML (yaml-language-server)
return {
  settings = {
    yaml = {
      validate = true,
      schemas = {
        kubernetes = {
          "*.yml,*.yaml",
          "k8s/*.yaml",
          "apps/*/manifests/*.yaml",
          "*.k8s.yaml",
        },
      },
    },
  },
}
