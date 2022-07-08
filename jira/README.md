# Overview

This Docker container makes it easy to get an instance of Jira Software, Service Management or Core up and running.

> Note: Jira Software will be referenced in the examples provided.

# Getting started

For the JIRA_HOME directory that is used to store application data (amongst other things) we recommend mounting a host directory as a data volume, or via a named volume if using a docker version >= 1.9.

Additionally, if running Jira in Data Center mode it is required that a shared filesystem is mounted. The mountpoint (inside the container) can be configured with JIRA_SHARED_HOME.

To get started you can use a data volume, or named volumes. In this example we'll use named volumes.

docker volume create --name jiraVolume
docker run -v jiraVolume:/var/atlassian/application-data/jira --name="jira" -d -p 8080:8080 atlassian/jira-software

Success. Jira is now available on [http://localhost:8080-](http://localhost:8080)

Please ensure your container has the necessary resources allocated to it. We recommend 2GiB of memory allocated to accommodate the application server. See System Requirements for further information.

To make it easy for you to get started with GitLab, here's a list of recommended next steps.

Already a pro? Just edit this README.md and make it your own. Want to make it easy? !

# Configuring Jira

This Docker image is intended to be configured from its environment; the provided information is used to generate the application configuration files from templates. This allows containers to be repeatably created and destroyed on-the-fly, as required in advanced cluster configurations. Most aspects of the deployment can be configured in this manner; the necessary environment variables are documented below. However, if your particular deployment scenario is not covered by these settings, it is possible to override the provided templates with your own; see the section Advanced Configuration below.

## Memory / Heap Size

If you need to override Jira's default memory allocation, you can control the minimum heap (Xms) and maximum heap (Xmx) via the below environment variables.

**JVM_MINIMUM_MEMORY** (default: 384m)

    The minimum heap size of the JVM

**JVM_MAXIMUM_MEMORY** (default: 768m)

    The maximum heap size of the JVM

**JVM_RESERVED_CODE_CACHE_SIZE** (default: 512m)

    The reserved code cache size of the JVM

## Reverse Proxy Settings

If Jira is run behind a reverse proxy server (e.g. a load-balancer or nginx server) as described here, then you need to specify extra options to make Jira aware of the setup. They can be controlled via the below environment variables.

**ATL_PROXY_NAME** (default: NONE)

    The reverse proxy's fully qualified hostname. CATALINA_CONNECTOR_PROXYNAME is also supported for backwards compatability.

**ATL_PROXY_PORT** (default: NONE)

    The reverse proxy's port number via which Jira is accessed. CATALINA_CONNECTOR_PROXYPORT is also supported for backwards compatability.

**ATL_TOMCAT_PORT** (default: 8080)

    The port for Tomcat/Jira to listen on. Depending on your container deployment method this port may need to be [exposed and published](https://docs.docker.com/v17.09/engine/userguide/networking/default_network/binding/).

**ATL_TOMCAT_SCHEME** (default: http)

    The protocol via which Jira is accessed. CATALINA_CONNECTOR_SCHEME is also supported for backwards compatability.

**ATL_TOMCAT_SECURE** (default: false)

    Set `'true'` if ATL_TOMCAT_SCHEME is `'https'`. CATALINA_CONNECTOR_SECURE is also supported for backwards compatability.

**ATL_TOMCAT_CONTEXTPATH** (default: NONE)

    The context path the application is served over. CATALINA_CONTEXT_PATH is also supported for backwards compatability.

The following Tomcat/Catalina options are also supported. For more information, see https://tomcat.apache.org/tomcat-7.0-doc/config/index.html.

**ATL_TOMCAT_MGMT_PORT** (default: 8005)
**ATL_TOMCAT_MAXTHREADS** (default: 100)
**ATL_TOMCAT_MINSPARETHREADS** (default: 10)
**ATL_TOMCAT_CONNECTIONTIMEOUT** (default: 20000)
**ATL_TOMCAT_ENABLELOOKUPS** (default: false)
**ATL_TOMCAT_PROTOCOL** (default: HTTP/1.1)
**ATL_TOMCAT_ACCEPTCOUNT** (default: 10)
**ATL_TOMCAT_MAXHTTPHEADERSIZE** (default: 8192)

## JVM configuration

If you need to pass additional JVM arguments to Jira, such as specifying a custom trust store, you can add them via the below environment variable

**JVM_SUPPORT_RECOMMENDED_ARGS**

    Additional JVM arguments for Jira


Example:

```
docker run -e JVM_SUPPORT_RECOMMENDED_ARGS=-Djavax.net.ssl.trustStore=/var/atlassian/application-data/jira/cacerts -v jiraVolume:/var/atlassian/application-data/jira --name="jira" -d -p 8080:8080 atlassian/jira-software

```

## Jira-specific settings

**ATL_AUTOLOGIN_COOKIE_AGE** (default: 1209600; two weeks, in seconds)

    The maximum time a user can remain logged-in with 'Remember Me'.

## Database configuration

It is optionally possible to configure the database from the environment, avoiding the need to do so through the web startup screen.

The following variables are all must all be supplied if using this feature:

**ATL_JDBC_URL**

    The database URL; this is database-specific.

**ATL_JDBC_USER**

    The database user to connect as.

**ATL_JDBC_PASSWORD**

    The password for the database user.

**ATL_DB_DRIVER**

    The JDBC driver class; 
    supported drivers are:
```
    com.microsoft.sqlserver.jdbc.SQLServerDriver
    com.mysql.jdbc.Driver
    oracle.jdbc.OracleDriver
    org.postgresql.Driver
```

    The driver must match the DB type (see next entry).

**ATL_DB_TYPE**

    The type of database; 
    valid supported values are:
```
    mssql
    mysql
    mysql57
    mysql8
    oracle10g
    postgres72
```

    Note that mysql is only supported for versions prior to 8.13, and mysql57 and mysql8 are only supported after. See the 8.13.x upgrade instructions for details.

The following variables may be optionally supplied when configuring the database from the environment:

**ATL_DB_SCHEMA_NAME**

    The schema name of the database. 
    Depending on the value of ATL_DB_TYPE, the following default values are used if no schema name is specified:
```
    mssql: dbo
    mysql: NONE
    mysql57: NONE
    mysql8: NONE
    oracle10g: NONE
    postgres72: public
```

> Note: Due to licensing restrictions Jira does not ship with MySQL or Oracle JDBC drivers. To use these databases you will need to copy a suitable driver into the container and restart it. For example, to copy the MySQL driver into a container named "jira", you would do the following:

```
docker cp mysql-connector-java.x.y.z.jar jira:/opt/atlassian/jira/lib
docker restart jira
```

For more information see the page Startup check: JIRA database driver missing.

### Optional database settings

The following variables are for the Tomcat JDBC connection pool, and are optional. For more information on these see: [https://tomcat.apache.org/tomcat-7.0-doc/jdbc-pool.html](https://tomcat.apache.org/tomcat-7.0-doc/jdbc-pool.html)

**ATL_DB_MAXIDLE** (default: 20)

**ATL_DB_MAXWAITMILLIS** (default: 30000)

**ATL_DB_MINEVICTABLEIDLETIMEMILLIS** (default: 5000)

**ATL_DB_MINIDLE** (default: 10)

**ATL_DB_POOLMAXSIZE** (default: 100)

**ATL_DB_POOLMINSIZE** (default: 20)

**ATL_DB_REMOVEABANDONED** (default: true)

**ATL_DB_REMOVEABANDONEDTIMEOUT** (default: 300)

**ATL_DB_TESTONBORROW** (default: false)

**ATL_DB_TESTWHILEIDLE** (default: true)

**ATL_DB_TIMEBETWEENEVICTIONRUNSMILLIS** (default: 30000)

**ATL_DB_VALIDATIONQUERY** (default: select 1)

The following settings only apply when using the Postgres driver:

**ATL_DB_KEEPALIVE** (default: true)

**ATL_DB_SOCKETTIMEOUT** (default: 240)

The following settings only apply when using the MySQL driver:

**ATL_DB_VALIDATIONQUERYTIMEOUT** (default: 3)

## Data Center configuration

This docker image can be run as part of a [Data Center](https://confluence.atlassian.com/enterprise/jira-data-center-472219731.html) cluster. You can specify the following properties to start Jira as a Data Center node, instead of manually configuring a cluster.properties file, See Installing Jira Data Center for more information on each property and its possible configuration.

### Cluster configuration

*Jira Software and Jira Service Management only*

**CLUSTERED** (default: false)

    Set `true` to enable clustering configuration to be used. This will create a cluster.properties file inside the container's $JIRA_HOME directory.

**JIRA_NODE_ID** (default: jira_node_

    The unique ID for the node. By default, this includes a randomly generated ID unique to each container, but can be overridden with a custom value.

**JIRA_SHARED_HOME** (default: $JIRA_HOME/shared)

    The location of the shared home directory for all Jira nodes. 

> Note: This must be real shared filesystem that is mounted inside the container. Additionally, see the note about UIDs.

**EHCACHE_PEER_DISCOVERY** (default: default)

    Describes how nodes find each other.

**EHCACHE_LISTENER_HOSTNAME** (default: NONE)

    The hostname of the current node for cache communication. Jira Data Center will resolve this this internally if the parameter isn't set.

**EHCACHE_LISTENER_PORT** (default: 40001)

    The port the node is going to be listening to. Depending on your container deployment method this port may need to be [exposed and published](https://docs.docker.com/v17.09/engine/userguide/networking/default_network/binding/).

**EHCACHE_OBJECT_PORT** (default: dynamic)

    The port number on which the remote objects bound in the registry receive calls. This defaults to a free port if not specified. This port may need to be [exposed and published](https://docs.docker.com/v17.09/engine/userguide/networking/default_network/binding/).

**EHCACHE_LISTENER_SOCKETTIMEOUTMILLIS** (default: 2000)

    The default timeout for the Ehcache listener.

**EHCACHE_MULTICAST_ADDRESS** (default: NONE)

    A valid multicast group address. Required when EHCACHE_PEER_DISCOVERY is set to `'automatic'` instead of `'default'`.

**EHCACHE_MULTICAST_PORT** (default: NONE)

    The dedicated port for the multicast heartbeat traffic. Required when EHCACHE_PEER_DISCOVERY is set to `'automatic'` instead of `'default'`. Depending on your container deployment method this port may need to be [exposed and published](https://docs.docker.com/v17.09/engine/userguide/networking/default_network/binding/).

**EHCACHE_MULTICAST_TIMETOLIVE** (default: NONE)

    A value between 0 and 255 which determines how far the packets will propagate. Required when EHCACHE_PEER_DISCOVERY is set to `'automatic'` instead of `'default'`.

**EHCACHE_MULTICAST_HOSTNAME** (default: NONE)

    The hostname or IP of the interface to be used for sending and receiving multicast packets. Required when EHCACHE_PEER_DISCOVERY is set to `'automatic'` instead of `'default'`.

### Shared directory and user IDs

By default the Jira application runs as the user jira, with a UID and GID of 2001. Consequently this UID must have write access to the shared filesystem. If for some reason a different UID must be used, there are a number of options available:

The Docker image can be rebuilt with a different UID.

Under Linux, the UID can be remapped using [user namespace remapping](https://docs.docker.com/engine/security/userns-remap/).

To preserve strict permissions for certain configuration files, this container starts as root to perform bootstrapping before running Jira under a non-privileged user account. If you wish to start the container as a non-root user, please note that Tomcat configuration will be skipped and a warning will be logged. You may still apply custom configuration in this situation by mounting a custom server.xml file directly to /opt/atlassian/jira/conf/server.xml

Database and Clustering bootstrapping will work as expected when starting this container as a non-root user.

## Container configuration

**ATL_FORCE_CFG_UPDATE** (default: false)

    The Docker [entrypoint](https://hub.docker.com/r/atlassian/entrypoint.py) generates application configuration on first start; not all of these files are regenerated on subsequent starts. This is deliberate, to avoid race conditions or overwriting manual changes during restarts and upgrades. However in deployments where configuration is purely specified through the environment (e.g. Kubernetes) this behaviour may be undesirable; this flag forces an update of all generated files.

    In Jira the affected files are: dbconfig.xml

    See [the entrypoint code](https://hub.docker.com/r/atlassian/entrypoint.py) for the details of how configuration files are generated.

**SET_PERMISSIONS** (default: true)

    Define whether to set home directory permissions on startup. Set to false to disable this behaviour.

## Advanced Configuration

As mentioned at the top of this section, the settings from the environment are used to populate the application configuration on the container startup. However in some cases you may wish to customise the settings in ways that are not supported by the environment variables above. In this case, it is possible to modify the base templates to add your own configuration. There are three main ways of doing this; modify our repository to your own image, build a new image from the existing one, or provide new templates at startup. We will briefly outline this methods here, but in practice how you do this will depend on your needs.

### Building your own image

**Clone** the Atlassian repository at https://bitbucket.org/atlassian-docker/docker-atlassian-jira/

**Modify or replace** the Jinja templates under config; 
> NOTE: The files must have the .j2 extensions. However you don't have to use template variables if you don't wish.

**Build** the new image with e.g: docker build --tag my-jira-8-image --build-arg JIRA_VERSION=8.x.x .

**Optionally** push to a registry, and deploy.

### Build a new image from the existing one

**Create** a new Dockerfile, which starts with the line e.g: FROM atlassian/jira-software:latest.

**Use** a COPY line to overwrite the provided templates.

**Build**, push and deploy the new image as above.

### Overwrite the templates at runtime

There are two main ways of doing this:

**If your container** is going to be long-lived, you can create it, modify the installed templates under /opt/atlassian/etc/, and then run it.

**Alternatively, you can create a volume containing your alternative templates**, and mount it over the provided templates at runtime with --volume my-config:/opt/atlassian/etc/.

# Logging

By default the Jira logs are written inside the container, under ${JIRA_HOME}/logs/. If you wish to expose this outside the container (e.g. to be aggregated by logging system) this directory can be a data volume or bind mount. Additionally, Tomcat-specific logs are written to /opt/atlassian/jira/logs/.

# Upgrades

To upgrade to a more recent version of Jira you can simply stop the jira container and start a new one based on a more recent image:
```
docker stop jira
docker rm jira
docker run ... (See above)
```
As your data is stored in the data volume directory on the host it will still be available after the upgrade.

> Note: Please make sure that you don't accidentally remove the jira container and its volumes using the -v option.

# Backup

For evaluations you can use the built-in database that will store its files in the Jira home directory. In that case it is sufficient to create a backup archive of the docker volume.

If you're using an external database, you can configure Jira to make a backup automatically each night. This will back up the current state, including the database to the jiraVolume docker volume, which can then be archived. Alternatively you can backup the database separately, and continue to create a backup archive of the docker volume to back up the Jira Home directory.

Read more about data recovery and backups: [https://confluence.atlassian.com/adminjiraserver071/backing-up-data-802592964.html](https://confluence.atlassian.com/adminjiraserver071/backing-up-data-802592964.html)
Shutdown

Depending on your configuration Jira may take a short period to shutdown any active operations to finish before termination. If sending a docker stop this should be taken into account with the --time flag.

Alternatively, the script /shutdown-wait.sh is provided, which will initiate a clean shutdown and wait for the process to complete. This is the recommended method for shutdown in environments which provide for orderly shutdown, e.g. Kubernetes via the preStop hook.

# Troubleshooting

These images include built-in scripts to assist in performing common JVM diagnostic tasks.

## Thread dumps

/opt/atlassian/support/thread-dumps.sh can be run via docker exec to easily trigger the collection of thread dumps from the containerized application. 
For example:
```
docker exec my_container /opt/atlassian/support/thread-dumps.sh
```
By default this script will collect 10 thread dumps at 5 second intervals. This can be overridden by passing a custom value for the count and interval, by using -c / --count and -i / --interval respectively. For example, to collect 20 thread dumps at 3 second intervals:
```
docker exec my_container /opt/atlassian/support/thread-dumps.sh --count 20 --interval 3
```
Thread dumps will be written to `$APP_HOME/thread_dumps/<date>`.

> Note: By default this script will also capture output from top run in 'Thread-mode'. This can be disabled by passing -n / --no-top

## Heap dump

/opt/atlassian/support/heap-dump.sh can be run via docker exec to easily trigger the collection of a heap dump from the containerized application. For example:
```
docker exec my_container /opt/atlassian/support/heap-dump.sh
```
A heap dump will be written to $APP_HOME/heap.bin. If a file already exists at this location, use -f / --force to overwrite the existing heap dump file.

## Manual diagnostics

The jcmd utility is also included in these images and can be used by starting a bash shell in the running container:

```
docker exec -it my_container /bin/bash
```