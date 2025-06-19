resource "kubernetes_namespace" "apps" {
  metadata {
    name = "apps"
  }
}

resource "kubernetes_service_account" "service" {
  metadata {
    name      = "workload-identity-service-account"
    namespace = kubernetes_namespace.apps.metadata[0].name
    annotations = {
      "azure.workload.identity/client_id" = azurerm_user_assigned_identity.example_mi.client_id
    }
    labels = {
      "azure.workload.identity/use" = true
    }
  }
}

resource "kubernetes_config_map" "configs" {
  metadata {
    name      = "workload-identity-config-map"
    namespace = kubernetes_namespace.apps.metadata[0].name
  }

  data = {
    managed_identity_id        = azurerm_user_assigned_identity.example_mi.client_id
    managed_identity_object_id = azurerm_user_assigned_identity.example_mi.principal_id
  }
}

#resource "kubernetes_pod" "pod" {
  #metadata {
    #name = "demo"
    #labels = {
      #aadpodidbinding =
    #}
  #}
#}
