# This Dockerfile is needed just to control the startup order
# see: https://docs.docker.com/compose/startup-order/
FROM unixelias/docker-dspace:5.6.1-alpha
RUN useradd -ms /bin/bash dspace \
    && usermod -a -G root dspace

COPY ./config/setup-postgres /dspace/bin
COPY ./config/start-dspace /dspace/bin

#Some configs for 6.0
COPY ./config/setenv.sh "$CATALINA_HOME"/bin
COPY ./config/server.xml "$CATALINA_HOME"/conf
COPY ./config/local.cfg /dspace/config

#EXPOSE 8080

CMD ["start-dspace"]
