#
# DSpace image
#

FROM ubuntu:16.04

MAINTAINER Elias Alves <elias.alves@ufvjm.edu.br>

ARG BUILD_DATE
ARG VCS_REF
ARG VCS_BRANCH
# Environment variables
ARG DSPACE_VERSION
ARG TOMCAT_MAJOR
ARG TOMCAT_VERSION
ARG MAVEN_MAJOR
ARG MAVEN_VERSION

# Build-time metadata as defined at http://label-schema.org
LABEL Name="Dspace v${DSPACE_VERSION}" \
      Version=$VCS_BRANCH \
      Architecture="x86_64" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Dspace" \
      org.label-schema.description="Deployment of Dspace on Docker" \
      org.label-schema.url="http://www.dspace.org/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/unixelias/docker-dspace" \
      org.label-schema.vendor="Elias Alves at UFVJM" \
      org.label-schema.version=$VCS_BRANCH \
      org.label-schema.version="latest" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.docker.cmd="docker run -d --link postgres -p 8080:8080 unixelias/docker-dspace"


ENV DPSACE_TGZ_URL=https://github.com/DSpace/DSpace/releases/download/dspace-$DSPACE_VERSION/dspace-$DSPACE_VERSION-release.tar.gz \
    MAVEN_TGZ_URL=http://apache.mirror.iweb.ca/maven/maven-$MAVEN_MAJOR/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    TOMCAT_TGZ_URL=https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

ENV CATALINA_HOME=/usr/local/tomcat DSPACE_HOME=/dspace

ENV PATH=$CATALINA_HOME/bin:$DSPACE_HOME/bin:$PATH

# Create Dspace user and adding to the sudoers group
RUN useradd -ms /bin/bash dspace \
    && usermod -a -G root dspace

WORKDIR /tmp

# Install pre dependencies and set locales
# To set locales you may you need to change some lines here (uncomment/change)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    bzip2 \
    curl \
    git \
#    locales \
#    tzdata \
    unzip \
    vim \
    xz-utils \
#    && locale-gen pt en es \
#    && echo "pt_BR pt_BR.UTF-8" >> /etc/locale.alias \
#    && unlink /etc/localtime \
#    && ln -s /usr/share/zoneinfo/Brazil/East /etc/localtime \
#    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# You can change the default S.O. language here
# ENV LANG='pt_BR.UTF-8' LANGUAGE='pt_BR:pt:en' LC_ALL='pt_BR.UTF-8'

# Install build dependencies and Java OpenJDK ubuntu latest
RUN apt-get update && apt-get upgrade -y\
    && apt-get install -y --no-install-recommends \
    default-jdk \
    default-jre \
    postgresql-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install runtime and dependencies
# Getting and unpacking Tomcat
RUN mkdir -p "$CATALINA_HOME" \
    && curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
    && tar -xf tomcat.tar.gz --strip-components=1 -C "$CATALINA_HOME" \
    && rm -rf tomcat.tar.gz

# Some configs for 6.0
COPY ./config/setenv.sh "$CATALINA_HOME"/bin
COPY ./config/server.xml "$CATALINA_HOME"/conf

# Getting and unpacking Maven
# Getting and unpacking Dspace
# # If you wanto to use the source version put this line
# # between the 1st line of next "RUN" command and "cd dspace"
# git clone https://github.com/unixelias/dspace.git -b dspace-6_x dspace &&
# Build, install and clean
RUN mkdir -p maven \
    && curl -fSL "$MAVEN_TGZ_URL" -o maven.tar.gz \
    && tar -xf maven.tar.gz --strip-components=1  -C maven \
    && rm -rf maven.tar.gz \
    && mkdir -p dspace \
    && curl -L "$DPSACE_TGZ_URL" -o dspace.tar.gz \
    && tar -xf dspace.tar.gz --strip-components=1  -C dspace \
    && rm -rf dspace.tar.gz \
    && apt-get update && apt-get upgrade -y\
    && apt-get install -y --no-install-recommends ant \
    && cd dspace && ../maven/bin/mvn -q package \
    && cd dspace/target/dspace-installer \
    && ant init_installation init_configs install_code copy_webapps \
    && rm -fr "$CATALINA_HOME/webapps" && mv -f /dspace/webapps "$CATALINA_HOME" \
    && sed -i s/CONFIDENTIAL/NONE/ /usr/local/tomcat/webapps/rest/WEB-INF/web.xml \
    && rm -fr ~/.m2 && rm -fr /tmp/* && apt-get remove -y ant \
    && rm -rf /usr/local/tomcat/webapps/oai \
    && rm -rf /usr/local/tomcat/webapps/sword \
    && rm -rf /usr/local/tomcat/webapps/swordv2 \
    && rm -rf /usr/local/tomcat/webapps/xmlui \
    && rm -rf ../maven \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install root filesystem
ADD ./rootfs /
COPY ./config/local.cfg /dspace/config

VOLUME $DSPACE_HOME/assetstore
VOLUME $DSPACE_HOME/config
VOLUME $DSPACE_HOME/history
VOLUME $DSPACE_HOME/log

WORKDIR $DSPACE_HOME

# Build info
RUN echo "Ubuntu GNU/Linux 16.04 (xenial) image. (`uname -rsv`)" >> /root/.built && \
    echo "- with `java -version 2>&1 | awk 'NR == 2'`" >> /root/.built && \
    echo "- with DSpace $DSPACE_VERSION on Tomcat $TOMCAT_VERSION"  >> /root/.built

EXPOSE 8080

CMD ["start-dspace"]
