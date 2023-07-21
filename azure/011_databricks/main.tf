# data "azurerm_client_config" "current" {}

# data "azuread_client_config" "current" {}

# data "databricks_current_user" "user" {}

data "databricks_user" "user" {
  user_name = juan_aguilar@epam.com
}

resource "azurerm_resource_group" "rg" {
  name     = "resourceGroup011"
  location = "westus2"
}

resource "azurerm_databricks_workspace" "databricks" {
  name                = "databricks"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "premium"
}

data "databricks_node_type" "smallest" {
  local_disk = true

  depends_on = [azurerm_databricks_workspace.databricks]
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true

  depends_on = [azurerm_databricks_workspace.databricks]
}

resource "databricks_cluster" "cluster" {
  cluster_name            = "cluster"
  node_type_id            = data.databricks_node_type.smallest.id
  spark_version           = data.databricks_spark_version.latest_lts.id
  autotermination_minutes = 60
  num_workers             = 1
}

resource "databricks_notebook" "get" {
  source = "${path.module}/scripts/getData.py"
  path   = "${data.databricks_current_user.user.home}/"
#  path   = "${data.databricks_current_user.user.home}/"
}

resource "databricks_notebook" "query" {
  source = "${path.module}/scripts/queryData.py"
  path   = "${data.databricks_user.user.home}/"
#  path   = "${data.databricks_user.user.home}/"
}
