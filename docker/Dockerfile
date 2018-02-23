#
# DSpace image
#

FROM ubuntu

MAINTAINER Elias Alves <elias.alves@ufvjm.edu.br>

ARG BUILD_DATE
ARG VCS_REF
ARG VCS_BRANCH
# Environment variables
ARG SOURCE_REPO
ARG SOURCE_BRANCH
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


ENV MAVEN_TGZ_URL=http://apache.mirror.iweb.ca/maven/maven-$MAVEN_MAJOR/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    TOMCAT_TGZ_URL=https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

ENV CATALINA_HOME=/usr/local/tomcat DSPACE_HOME=/dspace

ENV PATH=$CATALINA_HOME/bin:$DSPACE_HOME/bin:$PATH

WORKDIR /tmp

# Install pre dependencies and set locales
# To set locales you may you need to change some lines here (uncomment/change)
# Set languages and locales
RUN apt-get update && apt-get install -y locales tzdata \
    && touch /usr/share/locale/locale.alias \
    && localedef -i pt_BR -c -f UTF-8 -A /usr/share/locale/locale.alias pt_BR.UTF-8 \
    && echo "LC_ALL=pt_BR.UTF-8" >> /etc/environment \
    && echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "LANG=pt_BR.UTF-8" > /etc/locale.conf \
    && echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "LANG=en_US.UTF-8" > /etc/locale.conf \
    && echo "portuguese	pt_BR" >> /etc/locale.alias \
    && echo "portuguese	pt_BR.UTF-8" >> /etc/locale.alias \
    && echo "english	en_US" >> /etc/locale.alias \
    && echo "english	en_US.UTF-8" >> /etc/locale.alias \
    && locale-gen pt_BR pt_BR.UTF-8 en_US en_US.UTF-8 \
    && dpkg-reconfigure -f noninteractive locales \
    && unlink /etc/localtime \
    && ln -s /usr/share/zoneinfo/Brazil/East /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LANG='pt_BR.UTF-8' LANGUAGE='pt_BR:pt:en' LC_ALL='pt_BR.UTF-8'

# Install build dependencies and Java OpenJDK ubuntu latest
RUN apt-get update && apt-get upgrade -y\
    && apt-get install -y --no-install-recommends \
        bzip2 \
        curl \
        default-jdk \
        default-jre \
        git \
        postgresql-client \
        unzip \
        vim \
        xz-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install runtime and dependencies
# Getting and unpacking Tomcat
RUN mkdir -p "$CATALINA_HOME" \
    && curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
    && tar -xf tomcat.tar.gz --strip-components=1 -C "$CATALINA_HOME" \
    && rm -rf tomcat.tar.gz

# Some configs 
COPY ./config/setenv.sh "$CATALINA_HOME"/bin
COPY ./config/server.xml "$CATALINA_HOME"/conf

# Getting and unpacking Maven
# Build, install and clean
# Change install dir to default name: "dspace"
RUN mkdir -p maven \
    && curl -fSL "$MAVEN_TGZ_URL" -o maven.tar.gz \
    && tar -xf maven.tar.gz --strip-components=1  -C maven \
    && rm -rf maven.tar.gz \
    && git clone ${SOURCE_REPO} -b ${SOURCE_BRANCH} --single-branch dspace \
    && cd dspace \
    && sed -i "s#dspace.install.dir=/dspace57#dspace.install.dir=/dspace#" ./build.properties \
    && sed -i "s#db.url=jdbc:postgresql://localhost:5432/dspace57#db.url=jdbc:postgresql://localhost:5432/dspace#" ./build.properties \
    && ../maven/bin/mvn -q package \
    && cd dspace/target/dspace-installer \
    && ant init_installation init_configs install_code copy_webapps \
    && rm -fr "$CATALINA_HOME/webapps" && mv -f "$DSPACE_HOME/webapps" "$CATALINA_HOME" \
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
    echo "- with DSpace v${VCS_BRANCH} on Tomcat v$TOMCAT_VERSION"  >> /root/.built

EXPOSE 8080

CMD ["start-dspace"]
