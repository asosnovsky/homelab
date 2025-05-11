output "namespaces" {
  value = {
    plugins = {
      for k, v in helm_release.plugins :
      k => v.namespace
    }
  }
}
