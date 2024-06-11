# How to connect to one of the VMs

Get the private ssh key from ouputs and store it in a file

`terraform output --raw tls_private_key > private.txt`

Reduce permissions of the file as follows:

`chmod 600 private.txt`

Use the following command to log in:

`ssh -o UserKnownHostsFile=/dev/null -i private.txt zala@$(terraform --raw output public_ip)`

With that your `known_host` file will not be overwrited and avoid the ssh warning
message **REMOTE HOST IDENTIFICATION HAS CHANGED - IT IS POSSIBLE THAT SOMEONE
IS DOING SOMETHING NASTY**
