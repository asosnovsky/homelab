variable "local_storage_class_name" {}
variable "namespace" {}
variable "volumes" {
  type = map(object({
    storage   = string
    node_name = string
    data_path = string
  }))
}
