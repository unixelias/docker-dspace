# This Dockerfile is needed just to control the startup order
# see: https://docs.docker.com/compose/startup-order/
FROM unixelias/docker-dspace:dev

#Some configs for 6.0
COPY ./config/setenv.sh "$CATALINA_HOME"/bin
# COPY ./config/server.xml "$CATALINA_HOME"/conf
#
# COPY ./config/setup-postgres /dspace/bin
# COPY ./config/start-dspace /dspace/bin
# COPY ./config/local.cfg.UTF-8 /dspace/config
#
# RUN rm /dspace/config/local.cfg \
#     && iconv -f UTF-8 -t ISO-8859-1 /dspace/config/local.cfg.UTF-8 > /dspace/config/local.cfg \
#     && cat /dspace/config/local.cfg
    # && locale-gen pt en es \
    #&& unlink /etc/localtime \
    #&& ln -s /usr/share/zoneinfo/Brazil/East /etc/localtime
# #EXPOSE 8080
# ENV DSPACE_HOME=/dspace

# WORKDIR /dspace

CMD ["start-dspace"]
