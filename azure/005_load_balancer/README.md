# How to connect to one of the VMs

Use the following command to log in:

`ssh -o UserKnownHostsFile=/dev/null zala@$(terraform --raw output public_ip)`

With that your `known_host` file will not be overwrited and avoid the ssh warning
message **REMOTE HOST IDENTIFICATION HAS CHANGED - IT IS POSSIBLE THAT SOMEONE
IS DOING SOMETHING NASTY**
