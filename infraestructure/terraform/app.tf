resource "helm_release" "typeorm_app" {
  name = "typeorm-app"
  # Use Local Configuration for development/testing
  chart = "${path.module}/../charts/typeorm-app"

  # To use GitHub Container Registry (after publishing the chart):
  # repository = "oci://ghcr.io/YOUR_USERNAME/charts"
  # chart      = "typeorm-app"

  version = "0.1.0"

  values = [
    file("${path.module}/../charts/typeorm-app/values.yaml")
  ]

  depends_on = [kind_cluster.default, helm_release.mariadb]
}
