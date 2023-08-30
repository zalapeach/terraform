PAT=$1
ORG=$2
APPID=$3
SECRET=$4
TENANT=$5
sudo apt update
sudo apt upgrade -y
sudo apt install ansible azure-cli -y
sudo az login --service-principal -u $APPID -p $SECRET --tenant $TENANT
#sudo cp ./agent /home/zala/.ssh/id_rsa
#sudo cp ./agent.pub /home/zala/.ssh/id_rsa.pub
#sudo mv ./agent /root/.ssh/id_rsa
#sudo mv ./agent.pub /root.ssh/id_rsa.pub
#sudo chmod 600 /root/.ssh/id_*
#sudo chown root:root /root/.ssh/id_*
#sudo chmod 600 /home/zala/.ssh/id_*
#sudo chown zala:zala /home/zala/.ssh/id_*
#sudo sed '/host_key_checking/s/^#//' -i /etc/ansible/ansible.cfg
#sudo mkdir /myagent
#cd /myagent
#sudo wget https://vstsagentpackage.azureedge.net/agent/2.188.4/vsts-agent-linux-x64-2.188.4.tar.gz
#sudo tar zxvf ./vsts-agent-linux-x64-2.188.4.tar.gz
#sudo chmod -R 777 /myagent
#runuser -l zala -c "/myagent/config.sh --unattended --url https://dev.azure.com/${ORG} --auth pat --token ${PAT} --pool Demo"
#sudo /myagent/svc.sh install
#sudo /myagent/svc.sh start
#exit 0
