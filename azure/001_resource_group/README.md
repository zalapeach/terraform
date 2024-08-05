# Example 1

Creation of a resource group in azure using terraform.

# List of resource created

* A resource group called `resourceGroup001`.

# How to create

## Option 1

* Run pipeline **Terraform create - update infra**.
* In the **Terraform Example** option, select **001_resource_group**.

## Option 2

* In the repo, navigate to `azure/001_resource_group` folder.
* If it is the first time:
  * perform a `terraform init` to initialize.
  * then `terraform fmt` to check for format error.
  * followed by a `terraform validate` for validatation errors.
  * And optionally for a `terraform plan` to check resources to be created.
* Execute `terraform apply`, wait for completion.

# How to destroy

## Option 1

* Run pipeline **Terraform destroy infra**.
* In the **Terraform Example** option, select **001_resource_group**.

## Option 2

* In the repo, navigate to `azure/001_resource_group` folder
* Execute `terraform destroy`, wait for completion

# Outputs

* Resource group id

# Diagram

![Diagrama Exercise 1](/images/Exercise_001.svg)
