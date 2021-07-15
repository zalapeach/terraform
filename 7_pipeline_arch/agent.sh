PAT=$1
APPID=$2
SECRET=$3
TENANT=$4
sudo apt update
sudo apt upgrade -y
sudo apt install ansible azure-cli -y
sudo az login --service-principal -u $APPID -p $SECRET --tenant $TENANT
sudo mkdir /myagent
cd /myagent
sudo wget https://vstsagentpackage.azureedge.net/agent/2.188.4/vsts-agent-linux-x64-2.188.4.tar.gz
sudo tar zxvf ./vsts-agent-linux-x64-2.188.4.tar.gz
sudo chmod -R 777 /myagent
runuser -l zala -c "/myagent/config.sh --unattended --url https://dev.azure.com/JuanAguilar0507 --auth pat --token ${PAT} --pool Demo"
sudo /myagent/svc.sh install
sudo /myagent/svc.sh start
exit 0
