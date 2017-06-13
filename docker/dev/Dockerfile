#
# DSpace image
#

FROM openjdk:8-jdk

MAINTAINER Elias Alves <elias.alves@ufvjm.edu.br>
LABEL Name="Dspace para implementação do Repositório Institucional da UFVJM" \
      Version="0.0.1" \
      Architecture="x86_64" \
      Dockerfile_location="/root/buildinfo"

# Environment variables
ENV DSPACE_VERSION=6.0
ENV DPSACE_TGZ_URL=https://github.com/DSpace/DSpace/releases/download/dspace-${DSPACE_VERSION}/dspace-${DSPACE_VERSION}-release.tar.gz
ENV CATALINA_HOME=/usr/share/tomcat8 DSPACE_HOME=/dspace
ENV PATH=$CATALINA_HOME/bin:$DSPACE_HOME/bin:$PATH

WORKDIR /tmp

# Install runtime and dependencies
RUN apt-get update && apt-get -y upgrade \
    && apt-get install -y ant postgresql-client tomcat8 maven git \
    && git clone https://github.com/DSpace/DSpace.git -b dspace-6_x dspace \
    && cd dspace && mvn -q package \
    && cd dspace/target/dspace-installer \
    && ant init_installation init_configs install_code copy_webapps \
    && rm -fr "$CATALINA_HOME/webapps" && mv -f /dspace/webapps "$CATALINA_HOME" \
    && sed -i s/CONFIDENTIAL/NONE/ /usr/share/tomcat8/webapps/rest/WEB-INF/web.xml \
    && rm -fr /tmp/* && apt-get remove -y ant maven \
    && apt-get clean

# Install root filesystem
ADD ./rootfs /

WORKDIR /dspace

# Build info
RUN echo "Debian GNU/Linux 8 (jessie) image. (`uname -rsv`)" >> /root/.built && \
    echo "- with `java -version 2>&1 | awk 'NR == 2'`" >> /root/.built && \
    echo "- with DSpace $DSPACE_VERSION on Tomcat $TOMCAT_VERSION"  >> /root/.built

EXPOSE 8080
CMD ["start-dspace"]
