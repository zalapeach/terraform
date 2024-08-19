# Example 3

Creation of a storage account in azure using terraform

# List of resources created

* A resource group called `resourceGroup003`.
* A random string of 8 characters.
* A storage account named `storageRANDOM` (where RANDOM is changed by previouly
  random string).
* A blob container with name `container`.
* A `example` blob.

# How to create

## Option 1

* Run pipeline **Terraform create - update infra**.
* In the **Terraform Example** option, select **003_storage_account**.

## Option 2

* In the repo, navigate to `azure/003_storage_account` folder.
* If it is the first time:
  * perform a `terraform init` to initialize.
  * then `terraform fmt` to check for format error.
  * followed by a `terraform validate` for validatation errors.
  * And optionally for a `terraform plan` to check resources to be created.
* Execute `terraform apply`, wait for completion.

# How to destroy

## Option 1

* Run pipeline **Terraform destroy infra**.
* In the **Terraform Example** option, select **003_storage_account**.

## Option 2

* In the repo, navigate to `azure/003_storage_account` folder
* Execute `terraform destroy`, wait for completion

# Outputs

* Resource group id (`resource_group_id`)

# How to test

* Open azure portal and check that all resources are created.
* For blob, need to navigate to the created storage account, then to the
  container, and check if blob is created.

# Diagram

![Diagram Exercise 3](/images/Exercise_003.svg)
