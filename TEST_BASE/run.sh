docker run -p 8080:8080 --name container_alpine --log-driver json-file --log-opt max-size=10m -d test-alpine:jdk8;
docker run -p 8081:8080 --name container_ol --log-driver json-file --log-opt max-size=10m -d test-oraclelinux:jdk8;