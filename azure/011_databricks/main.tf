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
  path   = "/Shared/Demo"

  depends_on = [azurerm_databricks_workspace.databricks]
}

resource "databricks_notebook" "query" {
  source = "${path.module}/scripts/queryData.py"
  path   = "/Shared/Demo"

  depends_on = [azurerm_databricks_workspace.databricks]
}

resource "databricks_job" "job" {
  name = "demoJob"

  # existing_cluster_id = databricks_cluster.cluster.cluster_id
  # job_cluster {
    # job_cluster_key     = "cluster"
    # existing_cluster_id = databricks_cluster.cluster.cluster_id
  # }

  task {
    task_key            = "getTask"
    existing_cluster_id = databricks_cluster.cluster.id

    notebook_task {
      notebook_path = databricks_notebook.get.path
      source        = "WORKSPACE"
    }
  }

  task {
    task_key            = "queryTask"
    existing_cluster_id = databricks_cluster.cluster.id

    depends_on {
      task_key = "getTask"
    }

    notebook_task {
      notebook_path = databricks_notebook.query.path
      source        = "WORKSPACE"
    }
  }

  notification_settings {
    no_alert_for_skipped_runs  = false
    no_alert_for_canceled_runs = false
  }

  email_notifications {
    on_success = [var.org_email]
    on_failure = [var.org_email]
  }
}
