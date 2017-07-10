#
# DSpace image
#

FROM ubuntu

MAINTAINER Elias Alves <elias.alves@ufvjm.edu.br>

LABEL Name="Dspace" \
      Version="5.6-dev" \
      Architecture="x86_64" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Dspace" \
      org.label-schema.description="Deployment of Dspace to the Institutional Repository of UFVJM" \
      org.label-schema.url="http://www.dspace.org/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/unixelias/docker-dspace" \
      org.label-schema.vendor="Elias Alves at UFVJM" \
      org.label-schema.version="5.6-dev" \
      org.label-schema.version="dev" \
      org.label-schema.version="source" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.docker.cmd="docker run -d --link dspace_db:postgres -p 8080:8080 unixelias/docker-dspace"

# Environment variables
ENV DSPACE_VERSION=5.6 \
    TOMCAT_MAJOR=8 \
    TOMCAT_VERSION=8.5.16 \
    MAVEN_MAJOR=3 \
    MAVEN_VERSION=3.5.0

ENV DPSACE_TGZ_URL=https://github.com/DSpace/DSpace/releases/download/dspace-$DSPACE_VERSION/dspace-$DSPACE_VERSION-release.tar.gz \
    MAVEN_TGZ_URL=http://apache.mirror.iweb.ca/maven/maven-$MAVEN_MAJOR/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    TOMCAT_TGZ_URL=https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

ENV CATALINA_HOME=/usr/local/tomcat DSPACE_HOME=/dspace

ENV PATH=$CATALINA_HOME/bin:$DSPACE_HOME/bin:$PATH

WORKDIR /tmp

# Install pre dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    bzip2 \
    unzip \
    xz-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install build dependencies and Java OpenJDK ubuntu latest
RUN apt-get update \
    && apt-get install -y \
    ant \
    curl \
    default-jdk \
    default-jre \
    locales \
    postgresql-client \
    vim \
    && locale-gen pt_BR.UTF-8 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LANG='pt_BR.UTF-8' LANGUAGE='pt_BR:pt' LC_ALL='pt_BR.UTF-8'

# Install runtime and dependencies
# Getting and unpacking Dspace
RUN mkdir -p dspace \
    && curl -L "$DPSACE_TGZ_URL" -o dspace.tar.gz \
    && tar -xf dspace.tar.gz --strip-components=1  -C dspace \
    && rm -rf dspace.tar.gz

# Getting and unpacking Tomcat
RUN mkdir -p "$CATALINA_HOME" \
    && curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
    && tar -xf tomcat.tar.gz --strip-components=1 -C "$CATALINA_HOME" \
    && rm -rf tomcat.tar.gz

# Getting and unpacking Maven
RUN mkdir -p maven \
    && curl -fSL "$MAVEN_TGZ_URL" -o maven.tar.gz \
    && tar -xf maven.tar.gz --strip-components=1  -C maven \
    && rm -rf maven.tar.gz

# Build, install and clean
RUN cd dspace && ../maven/bin/mvn -q package \
    && cd dspace/target/dspace-installer \
    && ant init_installation init_configs install_code copy_webapps \
    && rm -fr "$CATALINA_HOME/webapps" && mv -f /dspace/webapps "$CATALINA_HOME" \
    && sed -i s/CONFIDENTIAL/NONE/ /usr/local/tomcat/webapps/rest/WEB-INF/web.xml \
    && rm -fr ~/.m2 && rm -fr /tmp/* && apt-get remove -y ant \
    && rm -rf /usr/local/tomcat/webapps/oai \
    && rm -rf /usr/local/tomcat/webapps/sword \
    && rm -rf /usr/local/tomcat/webapps/swordv2 \
    && rm -rf /usr/local/tomcat/webapps/xmlui \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install root filesystem
ADD ./rootfs /
COPY ./config/setenv.sh "$CATALINA_HOME"/bin
COPY ./config/local.cfg /dspace/config

WORKDIR /dspace

VOLUME /dspace/assetstore
VOLUME /dspace/config
VOLUME /dspace/history
VOLUME /dspace/log

# Build info
RUN echo "Ubuntu GNU/Linux 16.04 (xenial) image. (`uname -rsv`)" >> /root/.built && \
    echo "- with `java -version 2>&1 | awk 'NR == 2'`" >> /root/.built && \
    echo "- with DSpace $DSPACE_VERSION on Tomcat $TOMCAT_VERSION"  >> /root/.built

EXPOSE 8080

CMD ["start-dspace"]
