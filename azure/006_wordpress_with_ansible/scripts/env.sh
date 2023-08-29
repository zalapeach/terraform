#!/bin/bash

cat <<EOF
{
  "azure_devops_pat": "$AZDO_PERSONAL_ACCESS_TOKEN",
  "azure_devops_org": "$AZDO_ORG_SERVICE_URL",
  "azure_app_id": "$ARM_CLIENT_ID",
  "azure_app_secret": "$ARM_CLIENT_SECRET",
  "azure_app_tenant": "$ARM_TENANT_ID"
}
EOF
