if grep "autoindex on" /etc/nginx/sites-available/localhost > tmpfile
then
	sed -i "s/autoindex on/autoindex off/g" /etc/nginx/sites-available/localhost
else
	sed -i "s/autoindex off/autoindex on/g" /etc/nginx/sites-available/localhost
fi

service nginx restart > tmpfile
rm tmpfile
