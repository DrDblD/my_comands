# site https://gitee.com/pengzhile/atlassian-agent
# docker run -it --rm --entrypoint /bin/bash --name my-maven-project -v "$(pwd)":/usr/src/mymaven:z -w /usr/src/mymaven maven:3.3-jdk-8
docker run -it --rm --name my-maven-project -v "$(pwd)":/usr/src/mymaven:z -w /usr/src/mymaven maven:3.3-jdk-8 mvn package