terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "0.10.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "3.1.1"
    }
  }
}

provider "kind" {}

provider "helm" {
  kubernetes = {
    config_path = local.k8s_config_path
  }
}
