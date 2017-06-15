#
# DSpace image
#

FROM ubuntu

MAINTAINER Elias Alves <elias.alves@ufvjm.edu.br>
LABEL Name="Dspace para implementação do Repositório Institucional da UFVJM" \
      Version="0.0.2" \
      Architecture="x86_64" \
      Dockerfile_location="/root/buildinfo"

# Environment variables
ENV DSPACE_VERSION=5.6 \
    TOMCAT_MAJOR=9 \
    TOMCAT_VERSION=9.0.0.M21 \
    MAVEN_MAJOR=3 \
    MAVEN_VERSION=3.5.0

ENV DPSACE_TGZ_URL=https://github.com/DSpace/DSpace/releases/download/dspace-$DSPACE_VERSION/dspace-$DSPACE_VERSION-release.tar.gz \
    MAVEN_TGZ_URL=http://apache.mirror.iweb.ca/maven/maven-$MAVEN_MAJOR/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    TOMCAT_TGZ_URL=https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

ENV CATALINA_HOME=/usr/local/tomcat DSPACE_HOME=/dspace

ENV PATH=$CATALINA_HOME/bin:$DSPACE_HOME/bin:$PATH

WORKDIR /tmp

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    bzip2 \
    unzip \
    xz-utils

RUN apt-get install -y \
    ant \
    curl \
    default-jdk \
    default-jre \
    postgresql-client \
    vim

# Install runtime and dependencies

# Getting Dspace
RUN mkdir -p dspace \
    && curl -L "$DPSACE_TGZ_URL" -o dspace.tar.gz \
    && tar -xvf dspace.tar.gz --strip-components=1  -C dspace

# Getting Tomcat
RUN mkdir -p "$CATALINA_HOME" \
    && curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
    && tar -xvf tomcat.tar.gz --strip-components=1 -C "$CATALINA_HOME"

# Getting Maven
RUN mkdir -p maven \
    && curl -fSL "$MAVEN_TGZ_URL" -o maven.tar.gz \
    && tar -xvf maven.tar.gz --strip-components=1  -C maven

# Install
RUN cd dspace && ../maven/bin/mvn -q package \
    && cd dspace/target/dspace-installer \
    && ant fresh_install

#Copy and Clean
RUN && rm -fr "$CATALINA_HOME/webapps" && mv -f /dspace/webapps "$CATALINA_HOME" \
    && sed -i s/CONFIDENTIAL/NONE/ /usr/local/tomcat/webapps/rest/WEB-INF/web.xml \
    && rm -fr ~/.m2 && rm -fr /tmp/* && apt-get remove -y ant \
    && rm -rf /usr/local/tomcat/webapps/oai \
    && rm -rf /usr/local/tomcat/webapps/sword \
    && rm -rf /usr/local/tomcat/webapps/swordv2 \
    && rm -rf /usr/local/tomcat/webapps/xmlui \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install root filesystem
ADD ./rootfs

COPY log4j.properties /usr/local/tomcat/lib

WORKDIR /dspace

VOLUME /dspace/upload

# Build info
RUN echo "Ubuntu GNU/Linux 16.04 (xenial) image. (`uname -rsv`)" >> /root/.built && \
    echo "- with `java -version 2>&1 | awk 'NR == 2'`" >> /root/.built && \
    echo "- with DSpace $DSPACE_VERSION on Tomcat $TOMCAT_VERSION"  >> /root/.built

EXPOSE 8080

CMD ["start-dspace"]
