
docker run -ti -p 8080:8080 --rm --name jira \
      -v "$(pwd)"/agents:/opt/java/:z \
      -v "$(pwd)"/catalina.out:/opt/atlassian/jira/logs/catalina.out:z \
      -v "$(pwd)"/import/:/var/atlassian/application-data/jira/import/:z \
      debian:latest

cat <<EOF > postgres.sh
psql -c "CREATE USER jiradbadmin WITH PASSWORD 'password';"
createdb jiradb --encoding='UNICODE' --lc-collate='C' --lc-ctype='C' --template=template0
psql -c "GRANT ALL PRIVILEGES ON DATABASE jiradb TO jiradbadmin;"
EOF
chmod a+x postgres.sh
sudo su postgres
exit
rm postgres.sh


cat <<EOF > install.sh
export JIRA_VER=8.17.0
apt update 
apt install postgresql postgresql-contrib sudo wget fontconfig -y
update-rc.d postgresql enable
service postgresql start
wget https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-$JIRA_VER-x64.bin
chmod a+x atlassian-jira-software-$JIRA_VER-x64.bin
./atlassian-jira-software-$JIRA_VER-x64.bin
rm atlassian-jira-software-$JIRA_VER-x64.bin
export JIRA_HOME="/var/atlassian/application-data/jira"
export JIRA_INSTALL="/opt/atlassian/jira/"
EOF

cat <<EOF > first-start.sh
JAVA_OPTS="-javaagent:/opt/java/atlassian-agent-jar-with-dependencies.jar" /opt/atlassian/jira/bin/start-jira.sh
# /opt/atlassian/jira/jre/bin/java -jar /opt/java/atlassian-agent-jar-with-dependencies.jar -d -m kewot84116@oceore.com -n jira -o poidem -p jc -s XXXX-XXXX-XXXX-XXXX # copy in line
EOF

cat <<EOF > other-start.sh
rm -rf $JIRA_HOME/plugins/installed-plugins
JAVA_OPTS="-javaagent:/opt/java/atlassian-agent.jar" /opt/atlassian/jira/bin/start-jira.sh
EOF

# apt update
# apt install postgresql postgresql-contrib sudo wget -y
# update-rc.d postgresql enable
# service postgresql start
# sudo su postgres
# createuser -l jiradbadmin -P
# createdb jiradb --encoding='UNICODE' --lc-collate='C' --lc-ctype='C' -template=template0
# # createuser -l jiradbadmin -P # password
# psql 
#     CREATE USER jiradbadmin WITH PASSWORD 'password';
#     CREATE DATABASE jiradb WITH ENCODING 'UNICODE' LC_COLLATE 'C' LC_CTYPE 'C' TEMPLATE template0;
#     GRANT ALL PRIVILEGES ON DATABASE jiradb TO jiradbadmin;
# \q
# exit
# wget https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-8.19.1-x64.bin
# chmod a+x atlassian-jira-software-x.x.x-x64.bin
# sudo ./atlassian-jira-software-x.x.x-x64.bin
# rm -f /opt/atlassian/jira/atlassian-jira/WEB-INF/lib/atlassian-extras-3.4.6.jar
# wget https://omwtfyb.ir/atlassian-extras-3.4.6.jar
# mv atlassian-extras-3.4.6.jar /opt/atlassian/jira/atlassian-jira/WEB-INF/lib/