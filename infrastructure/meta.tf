resource "kubernetes_namespace" "hl" {
  metadata {
    name = "homelab"
  }
}

resource "kubernetes_labels" "masternode" {
  api_version = "v1"
  kind        = "Node"
  metadata {
    name = var.node_name_master
  }
  labels = {
    "homelab/master-node" = "yes"
  }
  field_manager = var.node_name_master
}
resource "kubernetes_labels" "nasnode" {
  api_version = "v1"
  kind        = "Node"
  metadata {
    name = var.node_name_nas
  }
  labels = {
    "homelab/nas-node" = "yes"
  }
  field_manager = var.node_name_nas
}
