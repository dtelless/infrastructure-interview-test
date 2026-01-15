resource "helm_release" "typeorm_app" {
  name       = "typeorm-app"
  repository = "oci://ghcr.io/dtelless/charts"
  chart      = "typeorm-app"

  version = "0.1.0"

  # values = [
  #   file("${path.module}/../charts/typeorm-app/values.yaml")
  # ]

  depends_on = [kind_cluster.default, helm_release.mariadb]
}
