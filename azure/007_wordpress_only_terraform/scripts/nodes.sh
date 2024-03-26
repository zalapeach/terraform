#!/bin/sh

runuser -l zala -c "sudo apt update -y"
runuser -l zala -c "sudo apt install apache2 php php-mysql unzip -y"
