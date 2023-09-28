#!/bin/sh

PAT=$1
ORG=$2
APPID=$3
SECRET=$4
TENANT=$5
runuser -l zala -c "sudo apt update -y"
runuser -l zala -c "sudo apt upgrade -y"
runuser -l zala -c "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash"
runuser -l zala -c "az login --service-principal -u $APPID -p $SECRET --tenant $TENANT"
runuser -l zala -c "sudo apt install plocate -y"
runuser -l zala -c "sudo apt install python3 -y"
runuser -l zala -c "sudo apt install python3-pip -y"
runuser -l zala -c "python3 -m pip install ansible"
runuser -l zala -c "python3 -m pip install -r https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt"
runuser -l zala -c "mkdir /home/zala/myagent"
runuser -l zala -c "wget -P /home/zala/myagent https://vstsagentpackage.azureedge.net/agent/3.225.0/vsts-agent-linux-x64-3.225.0.tar.gz"
runuser -l zala -c "tar zxvf /home/zala/myagent/vsts-agent-linux-x64-3.225.0.tar.gz -C /home/zala/myagent"
runuser -l zala -c "/home/zala/myagent/config.sh --unattended --url ${ORG} --auth pat --token ${PAT} --pool SelfHosted"
runuser -l zala -c "echo /home/zala/.local/bin:$PATH > /home/zala/myagent/.path"
runuser -l zala -c "cd myagent/; sudo ./svc.sh install"
runuser -l zala -c "cd myagent/; sudo ./svc.sh start"
exit 0
