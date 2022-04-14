p=$(pwd);
docker ps --all | grep /bin | awk '{print $1}' | xargs docker stop;
docker ps --all | grep /bin | awk '{print $1}' | xargs docker rm;
docker images --all | grep test | awk '{print $3}' | xargs docker rmi;
docker images --all | grep none | awk '{print $3}' | xargs docker rmi;
cp build-alpine/Dockerfile.alpine Dockerfile;
docker build -t test-alpine:jdk8 $p >> log.build;
rm Dockerfile;
cp build-oraclelinux/Dockerfile.ol Dockerfile;
docker build -t test-oraclelinux:jdk8 $p >> log.build