#
# DSpace image
#

FROM ubuntu

MAINTAINER Elias Alves <elias.alves@ufvjm.edu.br>
LABEL Name="Dspace para implementação do Repositório Institucional da UFVJM" \
      Version="0.0.1" \
      Architecture="x86_64" \
      Dockerfile_location="/root/buildinfo"

# Environment variables
ENV DSPACE_VERSION=5.6 TOMCAT_MAJOR=8 TOMCAT_VERSION=8.5.15
ENV TOMCAT_TGZ_URL=https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz \
    MAVEN_TGZ_URL=http://apache.mirror.iweb.ca/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz \
    DPSACE_TGZ_URL=https://github.com/DSpace/DSpace/releases/download/dspace-${DSPACE_VERSION}/dspace-${DSPACE_VERSION}-release.tar.gz
ENV CATALINA_HOME=/usr/local/tomcat DSPACE_HOME=/dspace
ENV PATH=$CATALINA_HOME/bin:$DSPACE_HOME/bin:$PATH

WORKDIR /tmp

RUN apt-get update && apt-get install -y --no-install-recommends bzip2 unzip xz-utils

RUN apt-get install -y vim curl ant postgresql-client default-jre default-jdk

# Install runtime and dependencies
RUN mkdir -p maven dspace "$CATALINA_HOME" \
    && curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
    && curl -fSL "$MAVEN_TGZ_URL" -o maven.tar.gz \
    && curl -L "$DPSACE_TGZ_URL" -o dspace.tar.gz \
    && tar -xvf tomcat.tar.gz --strip-components=1 -C "$CATALINA_HOME" \
    && tar -xvf maven.tar.gz --strip-components=1  -C maven \
    && tar -xvf dspace.tar.gz --strip-components=1  -C dspace \
    && cd dspace && ../maven/bin/mvn package \
    && cd dspace/target/dspace-installer \
    && ant init_installation init_configs install_code copy_webapps \
    && rm -fr "$CATALINA_HOME/webapps" && mv -f /dspace/webapps "$CATALINA_HOME" \
    && sed -i s/CONFIDENTIAL/NONE/ /usr/local/tomcat/webapps/rest/WEB-INF/web.xml \
    && rm -fr ~/.m2 && rm -fr /tmp/* && apt-get remove -y ant \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install root filesystem
ADD ./rootfs /

WORKDIR /dspace

# Build info
RUN echo "Debian GNU/Linux 8 (jessie) image. (`uname -rsv`)" >> /root/.built && \
    echo "- with `java -version 2>&1 | awk 'NR == 2'`" >> /root/.built && \
    echo "- with DSpace $DSPACE_VERSION on Tomcat $TOMCAT_VERSION"  >> /root/.built

EXPOSE 8080
CMD ["start-dspace"]
