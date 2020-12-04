# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: kiborroq <kiborroq@student.21-school.ru    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/11/30 11:02:58 by kiborroq          #+#    #+#              #
#    Updated: 2020/12/04 10:02:30 by kiborroq         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Install OS
FROM debian:buster

# Install Necessary Components
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install nginx
RUN apt-get -y install wget
RUN apt-get -y install vim
RUN apt-get -y install mariadb-server
RUN apt-get -y install php7.3-fpm php7.3-mysql php7.3-mbstring
RUN wget https://wordpress.org/latest.tar.gz
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz

# Adjust SSL
RUN openssl req -x509 -newkey rsa:2048 -nodes -days 365 -subj "/C=RU/ST=Moscow/L=Moscow/O=21school/OU=kiborroq/CN=localhost" -keyout /etc/ssl/private/localhost.key -out /etc/ssl/certs/localhost.crt;

# Adjust NGINX
COPY ./srcs/nginx-config ./etc/nginx/sites-available/localhost
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost
RUN rm -rf /etc/nginx/sites-enabled/default

# Adjust Access
RUN chown -R www-data /var/www/*
RUN chmod -R 755 /var/www/*

# Create Localhost Folder 
RUN mkdir /var/www/localhost

# Adjust PHPMYADMIN
RUN mkdir /var/www/localhost/phpmyadmin
RUN tar -xf phpMyAdmin-4.9.0.1-all-languages.tar.gz --strip-components 1 -C /var/www/localhost/phpmyadmin
RUN rm phpMyAdmin-4.9.0.1-all-languages.tar.gz
COPY ./srcs/config.inc.php /var/www/localhost/phpmyadmin

# Adjust WORDPRESS
RUN tar -xf latest.tar.gz -C /var/www/localhost
RUN rm latest.tar.gz
COPY ./srcs/wp-config.php /var/www/localhost/wordpress

# Copy Necessary Scripts to Container Root
COPY ./srcs/run_container.sh ./
COPY ./srcs/autoindex.sh ./
RUN chmod 755 ./autoindex.sh

# Declarate Ports
EXPOSE 80 443

CMD bash run_container.sh