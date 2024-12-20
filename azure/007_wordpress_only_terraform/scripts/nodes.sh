#!/bin/sh

$DB_PASSWORD=$1
$DB_HOST=$2
echo $DB_PASSWORD >> /home/zala/info.txt && echo $DB_HOST >> /home/zala/info.txt
runuser -l zala -c "echo ${DB_PASSWORD} >> /home/zala/info.txt && echo ${DB_HOST} >> /home/zala/info.txt"
runuser -l zala -c "sudo apt update -y"
runuser -l zala -c "sudo apt install apache2 php php-mysql unzip -y"
runuser -l zala -c "sudo systemctl enable apache2.service"
runuser -l zala -c "sudo systemctl restart apache2.service"
runuser -l zala -c "sudo touch /var/www/html/info.php"
runuser -l zala -c "sudo chmod 666 /var/www/html/info.php"
runuser -l zala -c "echo '<body style=\"background-color: #FFF\">' >> /var/www/html/info.php"
runuser -l zala -c "echo '  <h1>Node PHP version</h1>' >> /var/www/html/info.php"
runuser -l zala -c "echo '  <?php' >> /var/www/html/info.php"
runuser -l zala -c "echo '    phpinfo();' >> /var/www/html/info.php"
runuser -l zala -c "echo '  ?>' >> /var/www/html/info.php"
runuser -l zala -c "echo '</body>' >> /var/www/html/info.php"
runuser -l zala -c "sudo curl -o /var/www/html/latest.zip https://wordpress.org/latest.zip"
runuser -l zala -c "sudo unzip -d /var/www/html/ /var/www/html/latest.zip"
runuser -l zala -c "sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php"
runuser -l zala -c "sudo sed -i -e \"s/database_name_here/wordpress/g\" /var/www/html/wordpress/wp-config.php"
runuser -l zala -c "sudo sed -i -e \"s/username_here/root/g\" /var/www/html/wordpress/wp-config.php"
runuser -l zala -c "sudo sed -i -e \"s/password_here/${DB_PASSWORD}/g\" /var/www/html/wordpress/wp-config.php"
runuser -l zala -c "sudo sed -i -e \"s/localhost/${DB_HOST}/g\" /var/www/html/wordpress/wp-config.php"
exit 0
