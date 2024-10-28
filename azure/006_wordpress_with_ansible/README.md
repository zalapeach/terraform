# Example 6

Create all infrastructure required to run wordpress on premises using a public
facing load balancer, which will distribute requestes that tries to connect to
the application to the proper VM (will be 2 nodes).

The VMs will connect to a Maria DB instance installed on another VM.

In order to configure everything, a four VM will be created where an Azure
DevOps agent will be installed and using a pipeline will run Ansible playbooks
that will configure everything needed.

# List of resources created

* A resource group (`resourceGroup006`)
* A virtual network (`vnet01`)
* Three subnets (`frontent`, `backend`, `AzureBastionSubnet`)
* Two public IPs with static allocation (`WordPressIP` and `bastionIP`)
* A network security group that allows the following rules:
  * Traffic from any point to the port 80 of the VM nodes
  * Traffic from VM nodes to the port 3306 of the DB VM
  * Traffic from DB VM in the port 3306 of the VM nodes
  * Traffic from any point to the port 22 of all VMs
* A load balancer (`lb`)
* A backend address pool for the load balancer
* A health probe for the load balancer
* A load balancer rule
* 4 nic cards that will be linked to all VMs, 2 of them will be linked with the
  load balancer though the backend pool (called `nic00`, `nic01`, `nic02` and
  `nic03`)
* Four VMs (called `front-vm-00`, `front-vm-01`, `back-db-02` and `agent-vm-03`)
* An Azure Bastion to connect securely to all VMs
* An Azure VM extension to install all software required to the agent VM

# How to create

## Option 1

* Run pipeline **Terraform create - update infra**.
* In the **Terraform Example** option, select **006_wordpress_with_ansible**.

## Option 2

* In the repo, navigate to `azure/006_wordpress_with_ansible` folder.
* If it is the first time:
  * perform a `terraform init` to initialize.
  * then `terraform fmt` to check for format error.
  * followed by a `terraform validate` for validatation errors.
  * And optionally for a `terraform plan` to check resources to be created.
* Execute `terraform apply`, wait for completion.

# How to destroy

## Option 1

* Run pipeline **Terraform destroy infra**.
* In the **Terraform Example** option, select **006_wordpress_with_ansible**.

## Option 2

* In the repo, navigate to `azure/006_wordpress_with_ansible` folder
* Execute `terraform destroy`, wait for completion

# Outputs

* A map of some environment variables needed (`env`)
* The TLS private key (`tls_private_key`)
* The public IP of the Application Gateway (`appgtw_public_ip`)
* A map of all private IPs of all VMs (`private_ips`)

# How to test

* Open azure portal and check that all resources are created

**How to validate**

Follow these steps:

* Get the public IP from Wordpress IP resource
* On a web browser, navigate to the following URLs:
  * To validate apache on both nodes, go to http://WORDPRESS_IP, refresh
    multiple times to see different apache pages.
  * To validate PHP on both nodes, go to http://WORDPRESS_IP/info.php, refresh
    multiple times to see different PHP information pages.
  * To validate wordpress, navigate to http://WORDPRESS_IP/wordpress/, a demo
    wordpress page should appear.
  * To validate wordpress admin, navigate to
    http://WORDPRESS_IP/wordpress/wp-admin, use the credentials (username:
    **admin**, password: **check your keyvault**)

# Diagram

![Diagram Exercise 6](/images/Exercise_006.svg)
