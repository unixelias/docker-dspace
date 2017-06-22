# This Dockerfile is needed just to control the startup order
# see: https://docs.docker.com/compose/startup-order/
FROM unixelias/docker-dspace:test


COPY setup-postgres /dspace/bin
COPY start-dspace /dspace/bin
COPY log4j.properties /usr/local/tomcat/lib


RUN chmod +x /dspace/bin/setup-postgres \
    && chmod +x /dspace/bin/start-dspace

CMD ["start-dspace"]
