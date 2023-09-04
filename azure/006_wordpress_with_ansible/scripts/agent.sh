#!/bin/bash

PAT=$1
ORG=$2
APPID=$3
SECRET=$4
TENANT=$5
apt update
apt upgrade
sudo su - zala
sudo apt install ansible -y
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login --service-principal -u $APPID -p $SECRET --tenant $TENANT
mkdir /home/zala/myagent
cd /home/zala/myagent
wget https://vstsagentpackage.azureedge.net/agent/3.225.0/vsts-agent-linux-x64-3.225.0.tar.gz
tar zxvf ./vsts-agent-linux-x64-3.225.0.tar.gz
./config.sh --unattended --url ${ORG} --auth pat --token ${PAT} --pool SelfHosted
sudo ./svc.sh install
sudo ./svc.sh start
exit 0
