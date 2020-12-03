docker build -t test .
docker run -it --rm -p 29200:80 -p 443:443 test
