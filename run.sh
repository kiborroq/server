sudo docker build -t test .
sudo docker run -it -p 80:80 -p 443:443 test