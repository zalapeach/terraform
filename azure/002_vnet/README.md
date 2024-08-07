# Example 2

Creation of a virtual network in azure using terraform.

# List of resource created

* A resource group called `resourceGroup002`.
* A virtual network named `myTfVnet`

# How to create

## Option 1

* Run pipeline **Terraform create - update infra**.
* In the **Terraform Example** option, select **002_vnet**.

## Option 2

* In the repo, navigate to `azure/002_vnet` folder.
* If it is the first time:
  * perform a `terraform init` to initialize.
  * then `terraform fmt` to check for format error.
  * followed by a `terraform validate` for validatation errors.
  * And optionally for a `terraform plan` to check resources to be created.
* Execute `terraform apply`, wait for completion.

# How to destroy

## Option 1

* Run pipeline **Terraform destroy infra**.
* In the **Terraform Example** option, select **002_vnet**.

## Option 2

* In the repo, navigate to `azure/002_vnet` folder
* Execute `terraform destroy`, wait for completion

# Outputs

* Resource group id (`resource_group_id`)
* Virtual network id (`vnet_id`)

# How to test

* Open azure portal and check that all resources are created.

# Diagram

![Diagram Exercise 2](/images/Exercise_002.svg)
