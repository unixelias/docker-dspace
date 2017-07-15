# This Dockerfile is needed just to control the startup order
# see: https://docs.docker.com/compose/startup-order/
FROM unixelias/docker-dspace:5.7-ibict

#Some configs for 6.0
# COPY ./config/setenv.sh "$CATALINA_HOME"/bin
# COPY ./config/server.xml "$CATALINA_HOME"/conf
#
# COPY ./config/setup-postgres /dspace/bin
# COPY ./config/start-dspace /dspace/bin
RUN chmod ug+x "$CATALINA_HOME"/bin/setenv.sh \
    && chmod ug+x /dspace/bin/start-dspace \
    && chmod ug+x /dspace/bin/setup-postgres
    # && locale-gen pt en es \
    #&& unlink /etc/localtime \
    #&& ln -s /usr/share/zoneinfo/Brazil/East /etc/localtime
# #EXPOSE 8080
# ENV DSPACE_HOME=/dspace

# WORKDIR /dspace

CMD ["start-dspace"]
