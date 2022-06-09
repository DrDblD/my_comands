FROM alpine:latest

ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

ENV APP_NAME=jira
ENV RUN_USER=jira
ENV RUN_GROUP=jira
ENV RUN_UID=2001
ENV RUN_GID=2001
ENV JIRA_HOME=/var/atlassian/jira
ENV JIRA_INSTALL_DIR=/opt/atlassian/jira

WORKDIR /var/atlassian/application-data/jira

EXPOSE 8080

CMD ["/entrypoint.py"]

ENTRYPOINT ["/sbin/tini", "--"]

# Install build deps & required binaries
RUN apk add --no-cache --virtual .build-deps \
        curl \
        tar \
    && apk add --no-cache \
        py3-jinja2 \
        tini \
        openjdk11-jre \
        bash \
        fontconfig \
        ttf-dejavu

ARG JIRA_VERSION=8.19.1
ARG DOWNLOAD_URL=https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-${JIRA_VERSION}.tar.gz

# Setup Confluence Use+r & Group + directories
RUN addgroup -S -g ${RUN_GID} ${RUN_GROUP} && \
    adduser -S -u ${RUN_UID} -G ${RUN_GROUP} -h ${JIRA_HOME} -s /bin/bash ${RUN_USER} && \
    echo PATH=$PATH > /etc/environment && \
    mkdir -p ${JIRA_INSTALL_DIR}

# JIRA install/setup. Order of operations:
# 1. JIRA assets + install
# 4. Permissions
# 5. Update configurations

RUN curl -Ls ${DOWNLOAD_URL} | tar -xz --strip-components=1 -C "${JIRA_INSTALL_DIR}" && \
    chmod -R "u=rwX,g=rX,o=rX" ${JIRA_INSTALL_DIR}/ && \
    chown -R root. ${JIRA_INSTALL_DIR}/ && \
    chown -R ${RUN_USER}:${RUN_GROUP} ${JIRA_INSTALL_DIR}/logs && \
    chown -R ${RUN_USER}:${RUN_GROUP} ${JIRA_INSTALL_DIR}/temp && \
    chown -R ${RUN_USER}:${RUN_GROUP} ${JIRA_INSTALL_DIR}/work && \
    chown -R ${RUN_USER}:${RUN_GROUP} ${JIRA_INSTALL_DIR}/conf && \
    sed -i -e 's/^JVM_SUPPORT_RECOMMENDED_ARGS=""$/: \${JVM_SUPPORT_RECOMMENDED_ARGS:=""}/g' ${JIRA_INSTALL_DIR}/bin/setenv.sh && \
    sed -i -e 's/^JVM_\(.*\)_MEMORY="\(.*\)"$/: \${JVM_\1_MEMORY:=\2}/g' ${JIRA_INSTALL_DIR}/bin/setenv.sh && sed -i -e 's/-XX:ReservedCodeCacheSize=\([0-9]\+[kmg]\)/-XX:ReservedCodeCacheSize=${JVM_RESERVED_CODE_CACHE_SIZE:=\1}/g' ${JIRA_INSTALL_DIR}/bin/setenv.sh && \
    touch /etc/container_id && \
    chown ${RUN_USER}:${RUN_GROUP} /etc/container_id && \
    chown -R ${RUN_USER}:${RUN_GROUP} ${JIRA_HOME}

# Remove build dependencies
RUN apk del .build-deps

VOLUME [/var/atlassian/application-data/jira]

COPY entrypoint*.py /

COPY ./support /opt/atlassian/support

COPY ./templates/* /opt/atlassian/etc/