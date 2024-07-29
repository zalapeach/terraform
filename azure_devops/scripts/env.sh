#!/bin/bash

cat <<EOF
{
  "azure_ad_personal_object_id": "$AAD_PERSONAL_OBJECT_ID",
  "azure_devops_org": "$AZDO_ORG_SERVICE_URL",
  "azure_devops_pat": "$AZDO_PERSONAL_ACCESS_TOKEN",
  "azure_app_id": "$ARM_CLIENT_ID",
  "azure_app_secret": "$ARM_CLIENT_SECRET",
  "azure_app_object_id": "$ARM_CLIENT_OBJECT_ID",
  "azure_subscription_id": "$ARM_SUBSCRIPTION_ID",
  "azure_tenant_id": "$ARM_TENANT_ID",
  "email": "$TF_VAR_org_email",
  "terraform_cloud_token": "$TFE_TOKEN"
}
EOF
