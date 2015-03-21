CONTAINER_ID=`sudo docker ps -l -q`
sudo docker start $CONTAINER_ID
sudo docker exec -i -t $CONTAINER_ID bash
sudo docker stop $CONTAINER_ID
