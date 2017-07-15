# This Dockerfile is needed just to control the startup order
# see: https://docs.docker.com/compose/startup-order/
FROM unixelias/docker-dspace:5.x-dev

# RUN mv $DSPACE_HOME /dspace
# ENV PATH=$CATALINA_HOME/bin:/dspace/bin:$PATH
#
# RUN useradd -ms /bin/bash dspace \
#     && usermod -a -G root dspace
#
#
# #Some configs for 6.0
# COPY ./config/setenv.sh "$CATALINA_HOME"/bin
# COPY ./config/server.xml "$CATALINA_HOME"/conf
#COPY ./config/local.cfg /dspace/config
#
COPY ./config/setup-postgres /dspace/bin
# COPY ./config/start-dspace /dspace/bin
# #EXPOSE 8080
# ENV DSPACE_HOME=/dspace
# WORKDIR /dspace

CMD ["start-dspace"]
