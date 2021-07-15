TOKEN=$1
sudo apt update
sudo apt upgrade -y
sudo apt install ansible -y
sudo mkdir /myagent
cd /myagent
sudo wget https://vstsagentpackage.azureedge.net/agent/2.188.4/vsts-agent-linux-x64-2.188.4.tar.gz
sudo tar zxvf ./vsts-agent-linux-x64-2.188.4.tar.gz
sudo chmod -R 777 /myagent
runuser -l zala -c "/myagent/config.sh --unattended --url https://dev.azure.com/JuanAguilar0507 --auth pat --token ${TOKEN} --pool Demo"
sudo /myagent/svc.sh install
sudo /myagent/svc.sh start
exit 0
