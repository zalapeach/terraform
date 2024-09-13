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
  # need to add a timeout on notebook
  # because api is not ready after cluster creation
  source = "${path.module}/scripts/getData.py"
  path   = "/Shared/Demo/getData"

  depends_on = [azurerm_databricks_workspace.databricks]
}

resource "databricks_notebook" "query" {
  # need to add a timeout on notebook
  # because api is not ready after cluster creation
  source = "${path.module}/scripts/queryData.py"
  path   = "/Shared/Demo/queryData"

  depends_on = [azurerm_databricks_workspace.databricks]
}

resource "databricks_job" "job" {
  name = "demoJob"

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
    no_alert_for_skipped_runs  = true
    no_alert_for_canceled_runs = true
  }

  email_notifications {
    on_success = [var.org_email, var.org_email1]
    on_failure = [var.org_email, var.org_email1]
  }
}

# this section needs refinement 1 START
data "databricks_group" "admin" {
  display_name = "admins"
  depends_on   = [azurerm_databricks_workspace.databricks]
}

data "databricks_service_principal" "sp" {
  application_id = var.sp_client_id
  depends_on     = [azurerm_databricks_workspace.databricks]
}

resource "databricks_group_member" "sp_admin" {
  group_id  = data.databricks_group.admin.id
  member_id = data.databricks_service_principal.sp.id
}
# this section needs refinement 1 END
