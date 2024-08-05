# Terraform demos

The following examples are some demos for Terraform with Azure in order to learn how it works.

It also contains an automated way (used for personal purposes) to create and drop the underlying
infrastructure in order to run terraform pipelines in azure DevOps.

# How to setup everything

1. Create an account in Terraform Cloud
2. Create an account in Azure DevOps
3. Get an Azure subscription
4. Create a PAT (Personal Access Token) in Github, store it in a secure place
5. Create a PAT (Personal Access Token) in Azure DevOps, save it in a secure place
6. Create a token in Terraform Cloud and saved in a secure place
7. Download the repo
8. Create in the root of this project a `credentials.sh` file
9. Grant to credentials.sh executable permissions (`chmod 700 credentials.sh`)
10. Fill out this file as follows:

```
export ARM_TENANT_ID="your-azure-active-directory-tenant-id-mapped-to-your-subscription"
export ARM_SUBSCRIPTION_ID="your-azure-active-directory-subscription-id"

export AZDO_GITHUB_SERVICE_CONNECTION_PAT="github-token-created-in-step-4"
export AZDO_ORG_SERVICE_URL="https://dev.azure.com/your-organization-name"
export AZDO_PERSONAL_ACCESS_TOKEN="azure-devops-token-created-in-step-5"

export TFE_TOKEN="terraform-token-created-in-step-6"

# variables

export TF_VAR_env_arm_tenant_id=$ARM_TENANT_ID
export TF_VAR_env_arm_subscription_id=$ARM_SUBSCRIPTION_ID
export TF_VAR_env_azdo_github_pat=$AZDO_GITHUB_SERVICE_CONNECTION_PAT
export TF_VAR_env_azdo_pat=$AZDO_PERSONAL_ACCESS_TOKEN
export TF_VAR_env_azdo_url=$AZDO_ORG_SERVICE_URL
export TF_VAR_env_tfe_token=$TFE_TOKEN
export TF_VAR_org_email="personal1@email.com"
export TF_VAR_org_email1="personal2@email.com"
```

11. Export variables from `credentials.sh` with `source ./credentials.sh`
12. Execute the following commands inside `tf_cloud` folder to initialize terraform
and create HCL cloud infrastructure (note that this will use local as backend)

```
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

13. Execute previous list of commands now inside `azure_devops` folder to initialize
azure devops infrastructure (note that this will use HCL cloud as backend)
