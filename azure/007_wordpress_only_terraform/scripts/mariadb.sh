#!/bin/sh

runuser -l zala -c "sudo apt update -y"
runuser -l zala -c "sudo apt install mariadb-server"
runuser -l zala -c "mysql -u root <<-EOF
  UPDATE mysql.user SET Password=PASSWORD('$pass') WHERE User='root'
EOF"
