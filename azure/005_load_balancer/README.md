# Example 5

Creation of a public-facing load balancer with 2 VMs as backend pool in azure
using terraform

# List of resources created

* A resource group (`resourceGroup005`)
* A virtual network (`vnet01`)
* A subnet (`subnet01`)
* A public IP with static allocation (`lb_ip`)
* A network security group that allows traffic from any point to the port 22
* A load balancer (`lb`)
* A backend address pool for the load balancer
* A health probe for the load balancer
* A load balancer rule
* 2 nic cards that will be linked to 2 VMs and the load balancer though the
  backend pool (called `nic00` and `nic01`)
* An availability set (`availabilitySet`)
* Two VMs (called `ubuntu00` and `ubuntu01`)

# How to create

## Option 1

* Run pipeline **Terraform create - update infra**.
* In the **Terraform Example** option, select **005_load_balancer**.

## Option 2

* In the repo, navigate to `azure/005_load_balancer*` folder.
* If it is the first time:
  * perform a `terraform init` to initialize.
  * then `terraform fmt` to check for format error.
  * followed by a `terraform validate` for validatation errors.
  * And optionally for a `terraform plan` to check resources to be created.
* Execute `terraform apply`, wait for completion.

# How to destroy

## Option 1

* Run pipeline **Terraform destroy infra**.
* In the **Terraform Example** option, select **005_load_balancer**.

## Option 2

* In the repo, navigate to `azure/005_load_balancer` folder
* Execute `terraform destroy`, wait for completion

# Outputs

* The resource group id (`resource_group_id`)
* The virtual network id (`vnet_id`)
* The public IP (`public_ip`)
* The TLS private key (`tls_private_key`)
* The private IP for the first VM (`private_ip_linux_01`)
* The private IP for the second VM (`private_ip_linux_02`)

# How to test

* Open azure portal and check that all resources are created

**How to connect to one of the VMs**

Follow these steps:

* Get the private ssh key from ouputs and store it in a file (you can use
  `terraform output --raw tls_private_key > private.txt`).
* Reduce permissions of the file as follows(`chmod 600 private.txt`).
* Use the following command to log in (`ssh -o UserKnownHostsFile=/dev/null -i
  private.txt zala@$(terraform --raw output public_ip)`)

With that your `known_host` file will not be overwrited and avoid the ssh warning
message **REMOTE HOST IDENTIFICATION HAS CHANGED - IT IS POSSIBLE THAT SOMEONE
IS DOING SOMETHING NASTY**

Repeat many times until you got connection from both VMs.

# Diagram

![Diagram Exercise 5](/images/Exercise_005.svg)
