#!/bin/bash

PAT=$1
ORG=$2
APPID=$3
SECRET=$4
TENANT=$5
apt update
apt upgrade
apt install ansible -y
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login --service-principal -u $APPID -p $SECRET --tenant $TENANT
mkdir /myagent
cd /myagent
wget https://vstsagentpackage.azureedge.net/agent/3.225.0/vsts-agent-linux-x64-3.225.0.tar.gz
tar zxvf /myagent/vsts-agent-linux-x64-3.225.0.tar.gz
chmod -R 777 /myagent
runuser -l zala -c "/myagent/config.sh --unattended --url ${ORG} --auth pat --token ${PAT} --pool SelfHosted"
/myagent/svc.sh install
/myagent/svc.sh start
exit 0
