resource "kind_cluster" "default" {
  name           = var.cluster_name
  node_image     = var.kind_node_image
  wait_for_ready = true
  kubeconfig_path = local.k8s_config_path

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    dynamic "node" {
      for_each = range(var.control_plane_node_count)
      content {
        role = "control-plane"
      }
    }

    dynamic "node" {
      for_each = range(var.worker_node_count)
      content {
        role = "worker"
      }
    }
  }
}
