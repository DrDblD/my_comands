docker ps --all | grep container | awk '{print $1}' | xargs docker rm;
docker images --all | grep test | awk '{print $3}' | xargs docker rmi;
docker images --all | grep none | awk '{print $3}' | xargs docker rmi;