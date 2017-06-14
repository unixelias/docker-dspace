# This Dockerfile is needed just to control the startup order
# see: https://docs.docker.com/compose/startup-order/
FROM unixelias/docker-dspace:dev

ADD wait-for-postgres.sh /usr/local/bin

ENTRYPOINT ["wait-for-postgres.sh", "postgres"]
CMD ["start-dspace"]
