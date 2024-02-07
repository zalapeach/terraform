#!/bin/sh

#runuser -l zala -c "sudo apt update -y"
#runuser -l zala -c "sudo apt install mariadb-server"
#runuser -l zala -c "sudo systemctl start mariadb"
#runuser -l zala -c "sudo apt install python3-pip"
#runuser -l zala -c "python3 -m pip install PyMySQL"
#runuser -l zala -c "mysql -u root <<-EOF
  #UPDATE mysql.user SET Password=PASSWORD('$pass') WHERE User='root';
  #DELETE FROM mysql.user WHERE User='';
  #DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
  #DROP DATABASE test;
  #DELETE FROM mysql.db WHERE db='test' OR Db='test\_%';
  #FLUSH PRIVILEGES;
#EOF"
