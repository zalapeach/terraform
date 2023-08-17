#!/bin/bash

cat <<EOF
{
  "azure_devops_pat": $AZDO_PERSONAL_ACCESS_TOKEN,
  "azure_devops_org": $AZDO_ORG_SERVICE_URL
}
EOF
