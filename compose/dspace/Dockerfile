# This Dockerfile is needed just to control the startup order
# see: https://docs.docker.com/compose/startup-order/
FROM unixelias/docker-dspace:6.0

COPY setup-postgres /dspace/bin
COPY start-dspace /dspace/bin

#Some configs for 6.0
COPY setenv.sh "$CATALINA_HOME"/bin
COPY server.xml "$CATALINA_HOME"/conf
COPY local.cfg /dspace/config


CMD ["start-dspace"]
