output "pvc" {
  value = {
    for k, v in kubernetes_persistent_volume_claim.pvc :
    k => v.metadata[0]
  }
}
