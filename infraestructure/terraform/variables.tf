variable "cluster_name" {
  type        = string
  description = "The name of the cluster."
  default     = "kind-cluster"
}

variable "kind_node_image" {
  type        = string
  description = "The image version of the nodes"
  default     = "kindest/node:v1.31.2"
}

variable "control_plane_node_count" {
  type        = number
  description = "Number of control plane nodes"
  default     = 1
}

variable "worker_node_count" {
  type        = number
  description = "Number of worker nodes"
  default     = 3
}
