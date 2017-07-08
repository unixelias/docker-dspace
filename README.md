[![](https://images.microbadger.com/badges/image/unixelias/docker-dspace.svg)](https://microbadger.com/images/unixelias/docker-dspace "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/unixelias/docker-dspace.svg)](https://microbadger.com/images/unixelias/docker-dspace "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/commit/unixelias/docker-dspace.svg)](https://microbadger.com/images/unixelias/docker-dspace "Get your own commit badge on microbadger.com")  [![Build Status](https://travis-ci.org/unixelias/docker-dspace.svg?branch=latest)](https://travis-ci.org/unixelias/docker-dspace)

# What is DSpace?

![logo](https://github.com/unixelias/docker-dspace/raw/latest/logo.png)

[DSpace](https://wiki.duraspace.org/display/DSDOC6x/Introduction) is an open source repository software package typically used for creating open access repositories for scholarly and/or published digital content. While DSpace shares some feature overlap with content management systems and document management systems, the DSpace repository software serves a specific need as a digital archives system, focused on the long-term storage, access and preservation of digital content.

This image is based on official [Ubuntu image](https://hub.docker.com/_/ubuntu/) and use [Tomcat](http://tomcat.apache.org/) to run DSpace as defined in the [installation guide](https://wiki.duraspace.org/display/DSDOC6x/Installing+DSpace).

# Usage

DSpace use [PostgreSQL](http://www.postgresql.org/) as database.

We might use an external database or create a PostgreSQL container linked to the DSpace container.

## Postgres as a container

We have a custom [PostgreSQL Docker Image](https://hub.docker.com/r/unixelias/postgres-dspace/) used to change default locale of PostgreSQL to pt-BR. If you will use the default english language you may not need this, but it can be useful if you need a custom language. The source is avaliable at docker/postgres/Dockerfile [![](https://images.microbadger.com/badges/image/unixelias/postgres-dspace:9.6-dev.svg)](https://microbadger.com/images/unixelias/postgres-dspace:9.6-dev "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/unixelias/postgres-dspace:9.6-dev.svg)](https://microbadger.com/images/unixelias/postgres-dspace:9.6-dev "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/commit/unixelias/postgres-dspace:9.6-dev.svg)](https://microbadger.com/images/unixelias/postgres-dspace:9.6-dev "Get your own commit badge on microbadger.com")

First, we have to create the PostgreSQL container:

```
docker run -d --name dspace_db -p 5432:5432 unixelias/postgres-dspace
```

then run DSpace linking the PostgreSQL container:

```
docker run -d --link dspace_db:postgres -p 8080:8080 unixelias/docker-dspace
```

By default the database schema is created with the name `dspace` for a user `dspace` and password `dspace`, but it's possible to override this default settings :


```
docker run -d --link dspace_db:postgres \
        -e POSTGRES_SCHEMA=my_dspace \
        -e POSTGRES_USER=my_user \
        -e POSTGRES_PASSWORD=my_password \
        -p 8080:8080 unixelias/docker-dspace
```

We might also used the Docker compose project in the `sample` directory.

## External database  

When you use an external Postgres, you have to set some environment variables :
  - `POSTGRES_DB_HOST` (required): The server host name or ip(`postgres` by default).
  - `POSTGRES_DB_PORT` (optional): The server port (`5432` by default)
  - `POSTGRES_SCHEMA` (optional): The database schema (`dspace` by default)
  - `POSTGRES_USER` (optional): The user used by DSpace (`dspace` by default)
  - `POSTGRES_PASSWORD` (optional): The password of the user used by DSpace (`dspace` by default)
  - `POSTGRES_ADMIN_USER` (optional): The admin user creating the Database and the user (`postgres` by default)
  - `POSTGRES_ADMIN_PASSWORD` (optional): The password of the admin user


```
docker run -d  \
        -e POSTGRES_DB_HOST=my_host \
        -e POSTGRES_ADMIN_USER=my_admin \
        -e POSTGRES_ADMIN_PASSWORD=my_admin_password \
        -e POSTGRES_SCHEMA=my_dspace \
        -e POSTGRES_USER=my_user \
        -e POSTGRES_PASSWORD=my_password \
        -p 8080:8080 unixelias/docker-dspace
```


After few seconds DSpace should be accessible from:

 - JSP User Interface: http://localhost:8080/jspui
 - XML User Interface: http://localhost:8080/xmlui
 - OAI-PMH Interface: http://localhost:8080/oai/request?verb=Identify
 - REST: http://localhost:8080/rest

Note: The security constraint to tunnel request with SSL on the `/rest` endpoint has been removed, but it's very important to securize this endpoint in production through [Nginx](https://github.com/1science/docker-nginx) for example.

## Configure webapps installed

```
This development work just deploy `jspui` and `rest`.
```

DSpace consumed a lot of memory, and sometimes we don't really need all the DSpace webapps. So iy's possible to set an environment variables to control the webapps installed :

```
docker run -d --link dspace_db:postgres \
        -e DSPACE_WEBAPPS="jspui xmlui rest" \
        -p 8080:8080 unixelias/docker-dspace
```

The command above only installed the webapps `jspui` `xmlui` and `rest`.

# Build

This project is configured as an [automated build in Dockerhub](https://hub.docker.com/r/unixelias/docker-dspace/).

Each branch give the related image tag.  

# License

All the code contained in this repository, unless explicitly stated, is
licensed under ISC license.

A copy of the license can be found inside the [LICENSE](LICENSE) file.
