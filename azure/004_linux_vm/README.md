# Example 4

Creation of an ubuntu, internet public-facing vm in azure using terraform

# List of resources created

* A resource group (`resourceGroup004`)
* A virtual network (`vnet01`)
* A subnet (`subnet01`)
* A public IP with dynamic allocation (`publicIP`)
* A network security group that allows traffic from any point to the port 22
* A virtual network interface card (nic called `nic`) that is linked to the
  public IP and the subnet previously created
* A link between the nic and the network security group
* A tls certificate
* A virtual machine (`linux_vm`) that will use Ubuntu as OS and it is linked
  with the following resources:
  * The virtual network interface card
  * The TLS certificate

# How to create

## Option 1

* Run pipeline **Terraform create - update infra**.
* In the **Terraform Example** option, select **004_linux_vm**.

## Option 2

* In the repo, navigate to `azure/004_linux_vm` folder.
* If it is the first time:
  * perform a `terraform init` to initialize.
  * then `terraform fmt` to check for format error.
  * followed by a `terraform validate` for validatation errors.
  * And optionally for a `terraform plan` to check resources to be created.
* Execute `terraform apply`, wait for completion.

# How to destroy

## Option 1

* Run pipeline **Terraform destroy infra**.
* In the **Terraform Example** option, select **004_linux_vm**.

## Option 2

* In the repo, navigate to `azure/004_linux_vm` folder
* Execute `terraform destroy`, wait for completion

# Outputs

* The resource group id (`resource_group_id`)
* The virtual network id (`vnet_id`)
* The public IP (`public_ip`)
* The TLS private key (`tls_private_key`)

# How to test

* Open azure portal and check that all resources are created

**How to test connectivity**

* Get the public IP of the VM (you can use `terraform output --raw public_ip`).
* Get the private TLS and store it in a file (you can use the following command
  to accomplish that: `terraform output --raw tls_private_key > private.txt`).
* Reduce permissions of the `private.txt` with the command `chmod 600 private.txt`.
* Connect to the VM (you can use `ssh -i private.txt zala@$PUBLIC_IP` where
  `$PUBLIC_IP` needs to be replaced by the public ip retrieved in the first step).

# Diagram

![Diagram Exercise 4](/images/Exercise_004.svg)
