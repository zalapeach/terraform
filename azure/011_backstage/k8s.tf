resource "kubernetes_namespace" "backstage" {
  metadata {
    name = "backstage"

    labels = {
      "terraform.io/managed" = "true"
    }
  }
}


