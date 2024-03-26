#!/bin/sh

runuser -l zala -c "sudo apt update -y"
runuser -l zala -c "sudo apt install mariadb-server -y"
runuser -l zala -c "sudo systemctl start mariadb"
echo '[mysqld]' >> /etc/mysql/my.cnf
echo 'skip-network=0' >> /etc/mysql/my.cnf
echo 'skip-bind-address' >> /etc/mysql/my.cnf
runuser -l zala -c "sudo systemctl restart mariadb"
runuser -l zala -c "sudo apt install python3-pip -y"
runuser -l zala -c "python3 -m pip install PyMySQL"
runuser -l zala -c "sudo mysql -u root <<-EOF
  SET PASSWORD FOR 'root'@localhost = PASSWORD("tamarindo");
  DELETE FROM mysql.user WHERE User='';
  DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
  DROP DATABASE test;
  DELETE FROM mysql.db WHERE db='test' OR Db='test\_%';
  FLUSH PRIVILEGES;
  CREATE DATABASE wordpress;
  GRANT ALL PRIVILEGES ON *.* TO 'root'@'10.1.0.%' IDENTIFIED BY 'tamarindo' WITH GRANT OPTION
EOF"
