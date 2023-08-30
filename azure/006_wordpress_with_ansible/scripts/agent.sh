PAT=$1
ORG=$2
APPID=$3
SECRET=$4
TENANT=$5
sudo apt update
sudo apt upgrade
sudo apt install ansible -y
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
sudo az login --service-principal -u $APPID -p $SECRET --tenant $TENANT
sudo wget https://vstsagentpackage.azureedge.net/agent/3.225.0/vsts-agent-linux-x64-3.225.0.tar.gz
sudo tar zxvf ./vsts-agent-linux-x64-2.188.4.tar.gz
sudo chmod -R 777 /myagent
runuser -l zala -c "/myagent/config.sh --unattended --url https://dev.azure.com/${ORG} --auth pat --token ${PAT} --pool SelfHosted"
sudo /myagent/svc.sh install
sudo /myagent/svc.sh start
exit 0
