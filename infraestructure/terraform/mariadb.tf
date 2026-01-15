resource "helm_release" "mariadb" {
  name       = "mariadb"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mariadb"
  version    = "24.0.3"

  values = [
    file("${path.module}/values/mariadb/values.yaml")
  ]

  depends_on = [kind_cluster.default]
}
