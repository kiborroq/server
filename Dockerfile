# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: kiborroq <kiborroq@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/11/30 11:02:58 by kiborroq          #+#    #+#              #
#    Updated: 2020/11/30 17:49:30 by kiborroq         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install nginx
RUN apt-get -y install wget
RUN apt-get -y install mariadb-server
RUN apt-get -y install php7.3-fpm php7.3-common php7.3-mysql php7.3-gmp php7.3-curl php7.3-intl php7.3-mbstring php7.3-xmlrpc php7.3-gd php7.3-xml php7.3-cli php7.3-zip php7.3-soap php7.3-imap

COPY ./srcs/nginx-config.conf ./tmp/nginx-config.conf
COPY ./srcs/phpmyadmin-config.inc.php ./tmp/phpmyadmin-config.inc.php
COPY ./srcs/wp-config.php ./tmp/wp-config.php
COPY ./srcs/run_container.sh ./

CMD bash run_container.sh