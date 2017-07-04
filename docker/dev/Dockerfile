#
# DSpace image
#

FROM ubuntu

MAINTAINER Elias Alves <elias.alves@ufvjm.edu.br>
LABEL Name="Dspace para implementação do Repositório Institucional da UFVJM" \
      Version="6.0-alpha" \
      Architecture="x86_64" \
      Dockerfile_location="/root/buildinfo"

# Environment variables
ENV DSPACE_VERSION=6.0 \
    TOMCAT_MAJOR=8 \
    TOMCAT_VERSION=8.5.16 \
    MAVEN_MAJOR=3 \
    MAVEN_VERSION=3.5.0

ENV DPSACE_TGZ_URL=https://github.com/DSpace/DSpace/releases/download/dspace-$DSPACE_VERSION/dspace-$DSPACE_VERSION-release.tar.gz \
    MAVEN_TGZ_URL=http://apache.mirror.iweb.ca/maven/maven-$MAVEN_MAJOR/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    TOMCAT_TGZ_URL=https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

ENV CATALINA_HOME=/usr/local/tomcat DSPACE_HOME=/dspace

ENV PATH=$CATALINA_HOME/bin:$DSPACE_HOME/bin:$PATH

RUN useradd -ms /bin/bash dspace \
    && usermod -a -G root dspace

WORKDIR /tmp

# Install pre dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    bzip2 \
    git \
    sudo \
    unzip \
    xz-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install build dependencies and Java OpenJDK ubuntu latest
RUN apt-get update \
    && apt-get install -y \
    ant \
    curl \
    default-jdk default-jre \
    default-jre \
    locales \
    postgresql \
    postgresql-client \
    postgresql-contrib \
    python-software-properties \
    software-properties-common \
    vim \
    && locale-gen pt_BR.UTF-8 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LANG='pt_BR.UTF-8' LANGUAGE='pt_BR:pt' LC_ALL='pt_BR.UTF-8'

# Install runtime and dependencies
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

#Some configs for 6.0
COPY setenv.sh "$CATALINA_HOME"/bin
COPY server.xml "$CATALINA_HOME"/conf

# Get and build Dspace from source
# Getting and unpacking Dspace
RUN mkdir -p dspace \
    && curl -L "$DPSACE_TGZ_URL" -o dspace.tar.gz \
    && tar -xf dspace.tar.gz --strip-components=1  -C dspace \
    && rm -rf dspace.tar.gz \
    && cd dspace && ../maven/bin/mvn -q package

COPY ./rootfs/dspace/config/local.cfg dspace/dspace/target/dspace-installer
COPY ./rootfs/scripts/is-db-up.sh dspace/dspace/target/dspace-installer
# Install root filesystem
ADD ./rootfs /

#  Install and clean
RUN cd dspace/dspace/target/dspace-installer \
    && /etc/init.d/postgresql start \
    && /etc/init.d/postgresql reload \
    && /etc/init.d/postgresql restart \
    && ./is-db-up.sh \
    # Create user and schema
    && sudo -u postgres psql -W postgres -h 127.0.0.1 -p 5432 -c "CREATE USER dspace WITH NOSUPERUSER PASSWORD 'dspace';" \
    && sudo -u postgres psql -W postgres -h 127.0.0.1 -p 5432 -c "CREATE DATABASE dspace WITH ENCODING UNICODE OWNER dspace;" \
    && sudo -u postgres psql -W postgres -h 127.0.0.1 -p 5432 -d dspace -f /usr/share/postgresql/9.5/extension/pgcrypto--1.0.sql \
    # Create a new schema in this database named "extensions" (or whatever you want to name it)
    && sudo -u postgres psql -W postgres -h 127.0.0.1 -p 5432 -c "CREATE SCHEMA extensions;" \
    # Enable this extension in this new schema
    && sudo -u postgres psql -W postgres -h 127.0.0.1 -p 5432 -c "CREATE EXTENSION pgcrypto SCHEMA extensions;" \
    # Determine what your database "search_path" is set to
    # (the search_path is where your database will look for extensions)
    && sudo -u postgres psql -W postgres -h 127.0.0.1 -p 5432 -c "SHOW search_path;" \
    # Update your database's "search_path" to also search the new "extensions" schema.
    # You are just appending it on the end of the existing comma-separated list.
    && sudo -u postgres psql -W postgres -h 127.0.0.1 -p 5432 -c "ALTER DATABASE dspace SET search_path TO public,dspace,extensions;" \
    # Grant rights to call functions in the extensions schema to your dspace user
    && sudo -u postgres psql -W postgres -h 127.0.0.1 -p 5432 -c "GRANT USAGE ON SCHEMA extensions TO dspace;" \
    && ant fresh_install \
    && rm -fr "$CATALINA_HOME/webapps" && mv -f /dspace/webapps "$CATALINA_HOME" \
    && sed -i s/CONFIDENTIAL/NONE/ /usr/local/tomcat/webapps/rest/WEB-INF/web.xml \
    && rm -fr ~/.m2 && rm -fr /tmp/* && apt-get remove -y ant \
    && rm -rf /usr/local/tomcat/webapps/oai \
    && rm -rf /usr/local/tomcat/webapps/sword \
    && rm -rf /usr/local/tomcat/webapps/swordv2 \
    && rm -rf /usr/local/tomcat/webapps/xmlui \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /dspace

VOLUME /dspace/assetstore

# Build info
RUN echo "Ubuntu GNU/Linux 16.04 (xenial) image. (`uname -rsv`)" >> /root/.built && \
    echo "- with `java -version 2>&1 | awk 'NR == 2'`" >> /root/.built && \
    echo "- with DSpace $DSPACE_VERSION on Tomcat $TOMCAT_VERSION"  >> /root/.built

EXPOSE 8080

CMD ["start-dspace"]
