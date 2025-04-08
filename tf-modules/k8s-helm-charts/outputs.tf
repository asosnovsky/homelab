output "namespaces" {
  value = {
    plugins = {
      for k, v in helm_release.plugins :
      k => v.namespace
    }
    infra = {
      for k, v in helm_release.infra :
      k => v.namespace
    }
  }
}
