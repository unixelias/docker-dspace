# This Dockerfile is needed just to control the startup order
# see: https://docs.docker.com/compose/startup-order/
FROM unixelias/docker-dspace:6.0-dev

#Some configs for 6.0
# COPY ./config/setenv.sh "$CATALINA_HOME"/bin
# COPY ./config/server.xml "$CATALINA_HOME"/conf
#
# COPY ./config/setup-postgres /dspace/bin
# COPY ./config/start-dspace /dspace/bin
RUN sed -i "s#portuguese      pt_PT.ISO-8859-1#portuguese      pt_BR.UTF-8#" /etc/locale.alias \
    && sed -i "s#dspace.name = Acervo Institucional - R.I. UFVJM#dspace.name = Repositório Institucional - R.I. UFVJM#" /dspace/config/local.cfg \
    && iconv -f UTF-8 -t ISO-8859-1 /dspace/config/local.cfg > /dspace/config/local.cfg 
    # && locale-gen pt en es \
    #&& unlink /etc/localtime \
    #&& ln -s /usr/share/zoneinfo/Brazil/East /etc/localtime
# #EXPOSE 8080
# ENV DSPACE_HOME=/dspace

# WORKDIR /dspace

CMD ["start-dspace"]
