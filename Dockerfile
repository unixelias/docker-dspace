#
# 1science DSpace image
#

FROM java:openjdk-7u95
MAINTAINER 1science Devops Team <devops@1science.org>

ENV CATALINA_HOME=/usr/local/tomcat DSPACE_HOME=/usr/local/dspace PATH=$CATALINA_HOME/bin:$PATH
ENV TOMCAT_MAJOR=8 TOMCAT_VERSION=8.0.32 DSPACE_VERSION=5.4
ENV TOMCAT_TGZ_URL=https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

WORKDIR /tmp

# Install runtime and dependencies
RUN mkdir -p "$CATALINA_HOME"
RUN curl -fSL "$TOMCAT_TGZ_URL" | tar -xvf --strip-components=1 -C "$CATALINA_HOME"
RUN apt-get install -y maven
RUN curl -L https://github.com/DSpace/DSpace/releases/download/dspace-${DSPACE_VERSION}/dspace-${DSPACE_VERSION}-release.tar.gz | tar -xvf
RUN mvn package
RUN find -name *.war -exec cp -f {} "$CATALINA_HOME/webapps/"

# Clean
RUN rm -fr /tmp \
    && apt-get remove -y maven \


# Install root filesystem
ADD ./rootfs /

EXPOSE 8080

# Build info
RUN echo "Debian GNU/Linux 8 (jessie) image. (`uname -rsv`)" >> /root/.built && \
    echo "- with `java -version 2>&1 | awk 'NR == 2'`" >> /root/.built && \
    echo "- with Tomcat $TOMCAT_VERSION"  >> /root/.built

CMD ["catalina.sh", "run"]
