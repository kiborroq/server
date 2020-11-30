# Adjust SSL
openssl req -x509 -newkey rsa:2048 -nodes -days 365 -subj "/C=RU/ST=Moscow/L=Moscow/O=21school/OU=kiborroq/CN=website" -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;

# Adjust Access
chown -R www-data /var/www/*
chmod -R 755 /var/www/*

# Adjust Website Folder
mkdir /var/www/website
touch /var/www/website/index.php
echo "<?php phpinfo(); ?>" >> /var/www/website/index.php

# Adjust NGINX
mv /tmp/nginx-config /etc/nginx/sites-available/website
ln -s /etc/nginx/sites-available/website /etc/nginx/sites-enabled/website
rm -rf /etc/nginx/sites-enabled/default

# Adjust MySQL
service mysql start
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

# Adjust PHPMYADMIN
mkdir /var/www/website/phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
tar -xf phpMyAdmin-4.9.0.1-all-languages.tar.gz --strip-components 1 -C /var/www/website/phpmyadmin
mv /tmp/config.inc.php /var/www/website/phpmyadmin
rm phpMyAdmin-4.9.0.1-all-languages.tar.gz

# Adjust WORDPRESS
wget https://wordpress.org/latest.tar.gz
tar -xf latest.tar.gz -C /var/www/website/
mv /tmp/wp-config.php /var/www/website/wordpress/wp-config.php
rm latest.tar.gz

service php7.3-fpm start
service nginx start

bash