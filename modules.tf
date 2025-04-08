
# resource "helm_release" "local-chart-infrastructure" {
#   name      = "infrastructure"
#   chart     = "charts/infrastructure"
#   namespace = "default"
#   set = [{
#     name  = "ns.metallb"
#     value = module.k8s-helm-charts.namespaces.plugins.metallb
#   }]
#   values       = [file("./values.yaml")]
#   timeout      = 120
#   force_update = true
# }`

# module "k8s-helm-charts" {
#   source = "./tf-modules/k8s-helm-charts"
# }

# output "ns" {
#   value = module.k8s-helm-charts.namespaces
# }
