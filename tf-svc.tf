resource "kubernetes_service_v1" "argocd-metallb" {
  metadata {
    name      = "argo-cd-server"
    namespace = module.k8s-helm-charts.namespaces.plugins.argo-cd
    annotations = {
      "metallb.universe.tf/loadBalancerIPs" : "10.0.100.2"
    }
  }
  spec {
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = 8080
      name        = "http"
    }
    port {
      port        = 443
      target_port = 8080
      name        = "https"
    }
    selector = {
      "app.kubernetes.io/instance" : "argo-cd"
      "app.kubernetes.io/name" : "argocd-server"
    }
  }
}
