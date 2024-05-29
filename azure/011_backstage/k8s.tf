resource "kubernetes_namespace" "backstage" {
  metadata {
    name = "backstage"

    labels = {
      "terraform.io/managed" = "true"
    }
  }
}

resource "kubernetes_secret" "postgres" {
  metadata {
    name      = "postgres-secrets"
    namespace = kubernetes_namespace.backstage.metadata[0].name
  }

  data {
    POSTGRES_USER     = "TEST"
    POSTGRES_PASSWORD = "TEST"
  }
}
