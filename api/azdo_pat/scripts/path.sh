#!/bin/bash

#ACCESS_TOKEN=$(az account get-access-token \
  #--resource 499b84ac-1321-427f-aa17-267ca6975798 \
  #--query accessToken -o tsv)

#curl -H "Content-Type: application/json" \
  #-u :7RruEK0R3zcOOSwl3aTrMgfZGXJBuODuiES41jJaTTAsNiuNtJTNJQQJ99AKACAAAAAc0or1AAASAZDOCbNB \
  #https://dev.azure.com/JuanAguilar0507/terraform/_apis/pipelines?api-version=7.2-preview.1

#echo ""

#curl -H "Content-Type: application/json" \
  #-u ado:7RruEK0R3zcOOSwl3aTrMgfZGXJBuODuiES41jJaTTAsNiuNtJTNJQQJ99AKACAAAAAc0or1AAASAZDOCbNB \
  #https://vssps.dev.azure.com/JuanAguilar0507/_apis/tokens/pats?api-version=7.2-preview.1

  #https://vssps.dev.azure.com/JuanAguilar0507/_apis/tokens/pats?api-version=7.2-preview.1

#curl -H "Content-Type: application/json" \
  #-H "Autorization: Bearer $ACCESS_TOKEN" \
  #-d '{ "displayName": "new_token", "scope": "app_token", "validTo": "2020-12-01T23:46:23.319Z", "allOrgs": false }' \
  #-X POST \
  #https://dev.azure.com/JuanAguilar0507/_apis/tokens/pats?api-version=7.2-preview.1

#cat <<EOF
#{
  #"token": "$TOKEN"
#}
#EOF
