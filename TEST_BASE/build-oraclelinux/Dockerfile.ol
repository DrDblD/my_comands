# init ARGS

ARG OL_VERSION=3.15.4
ARG JDK=jdk-8u311-linux-x64.tar.gz
# ARG JDK=jdk-8u321-linux-aarch64.tar.gz

FROM oraclelinux:7-slim as builder

ARG JDK

# Since the files is compressed as tar.gz first yum install gzip and tar
RUN set -eux; \
	yum install -y \
		gzip \
		tar \
        wget \
	; \
	rm -rf /var/cache/yum

# Default to UTF-8 file.encoding
ENV LANG en_US.UTF-8

# Environment variables for the builder image.  
# Required to validate that you are using the correct file

ENV JAVA_PKG=${JDK} \
	JAVA_HOME=/usr/java/jdk-8 \
    TOMCAT_PATH=/opt/tomcat

COPY ./lib/${JDK} /tmp/jdk.tgz

RUN set -eux; \
	mkdir -p "$JAVA_HOME"; \
    mkdir -p "$TOMCAT_PATH"; \
	tar --extract --file /tmp/jdk.tgz --directory "$JAVA_HOME" --strip-components 1; \
    wget -q https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.109/bin/apache-tomcat-7.0.109.tar.gz -O /tmp/tomcat.tgz; \
    tar --extract --file /tmp/tomcat.tgz --directory "$TOMCAT_PATH" --strip-components 1;

## Get a fresh version of SLIM for the final image

FROM oraclelinux:7-slim

# Default to UTF-8 file.encoding
ENV LANG en_US.UTF-8

ENV JAVA_VERSION=1.8.0_311 \
	JAVA_HOME=/usr/java/jdk-8 
	
ENV	PATH $JAVA_HOME/bin:$PATH

# Copy the uncompressed Java Runtime from the builder image
COPY --from=builder $JAVA_HOME $JAVA_HOME
COPY --from=builder /opt/tomcat /opt/tomcat
##
RUN	yum -y update; \
	rm -rf /var/cache/yum; \
	ln -sfT "$JAVA_HOME" /usr/java/default; \
	ln -sfT "$JAVA_HOME" /usr/java/latest; \
	for bin in "$JAVA_HOME/bin/"*; do \
		base="$(basename "$bin")"; \
		[ ! -e "/usr/bin/$base" ]; \
		alternatives --install "/usr/bin/$base" "$base" "$bin" 20000; \
	done;

CMD ["/opt/tomcat/bin/catalina.sh", "run"]