#
# 1science DSpace image
#

FROM java:openjdk-7u95
MAINTAINER 1science Devops Team <devops@1science.org>

# Environment variables
ENV DSPACE_VERSION=5.4 \
    TOMCAT_TGZ_URL=https://www.apache.org/dist/tomcat/tomcat-8/v8.0.32/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz \
    MAVEN_TGZ_URL=http://apache.mirror.iweb.ca/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz \
    DPSACE_TGZ_URL=https://github.com/DSpace/DSpace/releases/download/dspace-${DSPACE_VERSION}/dspace-${DSPACE_VERSION}-release.tar.gz \
    CATALINA_HOME=/usr/local/tomcat DSPACE_HOME=/usr/local/dspace PATH=$CATALINA_HOME/bin:$PATH

WORKDIR /tmp

# Install runtime and dependencies
RUN mkdir -p maven dspace "$CATALINA_HOME"
RUN curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz
RUN curl -fSL "$MAVEN_TGZ_URL" -o maven.tar.gz
RUN curl -L "$DPSACE_TGZ_URL" -o dspace.tar.gz
RUN tar -xvf tomcat.tar.gz --strip-components=1 -C "$CATALINA_HOME"
RUN tar -xvf maven.tar.gz --strip-components=1  -C maven
RUN tar -xvf dspace.tar.gz --strip-components=1  -C dspace
RUN cd dspace && ../maven/bin/mvn package
RUN find -name *.war -exec cp -f {} "$CATALINA_HOME/webapps/" \;
RUN mv dspace /usr/local

# Clean
RUN rm -fr /tmp/* && rm -fr ~/.m2


# Install root filesystem
ADD ./rootfs /

WORKDIR /usr/local/dspace

# Build info
RUN echo "Debian GNU/Linux 8 (jessie) image. (`uname -rsv`)" >> /root/.built && \
    echo "- with `java -version 2>&1 | awk 'NR == 2'`" >> /root/.built && \
    echo "- with Tomcat $TOMCAT_VERSION"  >> /root/.built

EXPOSE 8080
CMD ["catalina.sh", "run"]
