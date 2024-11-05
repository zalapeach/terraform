#!/bin/sh

runuser -l zala -c "sudo apt update -y"
runuser -l zala -c "sudo apt install apache2 php php-mysql unzip -y"
runuser -l zala -c "sudo systemctl enable apache2.service"
runuser -l zala -c "sudo systemctl restart apache2.service"
runuser -l zala -c "sudo touch /var/www/html/info.php"
runuser -l zala -c "sudo chmod 666 /var/www/html/info.php"
runuser -l zala -c "echo '<body style="background-color: #FFF">' >> /var/www/html/info.php"
runuser -l zala -c "echo '  <h1>Node PHP version</h1>' >> /var/www/html/info.php"
runuser -l zala -c "echo '  <?php' >> /var/www/html/info.php"
runuser -l zala -c "echo '    phpinfo();' >> /var/www/html/info.php"
runuser -l zala -c "echo '  ?>' >> /var/www/html/info.php"
runuser -l zala -c "echo '</body>' >> /var/www/html/info.php"
