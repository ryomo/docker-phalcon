TAG='ryomo:phalcon'
CURRENT_DIR=`pwd`

sudo docker build -t $TAG .
# sudo docker build --no-cache -t $TAG .
sudo docker run -d -p 80:80 -p 443:443 -v $CURRENT_DIR/html:/var/www/html $TAG

CONTAINER_ID=`sudo docker ps -l -q`
sudo docker stop $CONTAINER_ID
