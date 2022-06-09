
# docker run -ti -p 8080:8080 --rm --name jira \
#       -v "$(pwd)"/agents:/opt/java/:z \
#       -v "$(pwd)"/catalina.out:/opt/atlassian/jira/logs/catalina.out:z \
#       -v "$(pwd)"/import/:/var/atlassian/application-data/jira/import/:z \
#       debian:latest

cat <<EOF > runtime.sh
# JIRA_VER=8.17.0
# JIRA_HOME="/var/atlassian/application-data/jira"
# JIRA_INSTALL="/opt/atlassian/jira/"
export JIRA_VER=8.19.1
export JIRA_HOME="/var/atlassian/application-data/jira"
export JIRA_INSTALL="/opt/atlassian/jira/"
# setenv JIRA_VER "8.17.0"
# setenv JIRA_HOME "/var/atlassian/application-data/jira"
# setenv JIRA_INSTALL "/opt/atlassian/jira/"
EOF
chmod a+x runtime.sh
source runtime.sh
echo -e "JIRA_VER = $JIRA_VER\nJIRA_INSTALL = $JIRA_INSTALL\nJIRA_HOME = $JIRA_HOME\n"

cat <<EOF > install.sh
apt update 
apt install postgresql postgresql-contrib -y
update-rc.d postgresql enable
EOF
chmod a+x install.sh
./install.sh
rm install.sh

cat <<EOF > install.sh
test -f /opt/atlassian-agent.jar || cp /opt/java/atlassian-agent-jar-with-dependencies.jar /opt/atlassian-agent.jar
apt update 
apt install postgresql postgresql-contrib wget fontconfig -y
update-rc.d postgresql enable
service postgresql start
wget https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-$JIRA_VER-x64.bin
chmod a+x atlassian-jira-software-$JIRA_VER-x64.bin
./atlassian-jira-software-$JIRA_VER-x64.bin
rm atlassian-jira-software-$JIRA_VER-x64.bin
EOF
chmod a+x install.sh
./install.sh
rm install.sh

cat <<EOF > postgres.sh
psql -c "CREATE USER jiradbadmin WITH PASSWORD 'password';"
createdb jiradb --encoding='UNICODE' --lc-collate='C' --lc-ctype='C' --template=template0
psql -c "GRANT ALL PRIVILEGES ON DATABASE jiradb TO jiradbadmin;"
EOF
chown -R postgres:postgres postgres.sh
chmod +x postgres.sh
su -c /postgres.sh postgres
rm postgres.sh

# $JIRA_INSTALL/jre/bin/java -jar /opt/atlassian-agent.jar -d -m bayipe3522@oceore.com -n jira -o poidem -p jira -s XXXX-XXXX-XXXX-XXXX # copy in line

cat <<EOF > start.sh
#! /bin/bash
JAVA_OPTS="-javaagent:/opt/atlassian-agent.jar" $JIRA_INSTALL/bin/start-jira.sh
EOF
chmod a+x start.sh

cat <<EOF > stop.sh
#! /bin/bash
JAVA_OPTS="-javaagent:/opt/atlassian-agent.jar" $JIRA_INSTALL/bin/stop-jira.sh
EOF
chmod a+x stop.sh


# docker commit jira jira:debian-11-postgres-13
# docker tag jira:debian-11-postgres-13 jira:latest