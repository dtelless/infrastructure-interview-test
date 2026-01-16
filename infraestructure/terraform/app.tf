resource "helm_release" "typeorm_app" {
  name       = "typeorm-app"
  repository = "oci://registry-1.docker.io/dtelless"
  chart      = "typeorm-app"
  version    = "0.1.0"


  values = [
    file("${path.module}/values/typeorm-app/values.yaml")
  ]

  depends_on = [kind_cluster.default, helm_release.mariadb]
}
