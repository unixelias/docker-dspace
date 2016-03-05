[![](https://badge.imagelayers.io/1science/dspace:latest.svg)](https://imagelayers.io/?images=1science/dspace:latest 'Get your own badge on imagelayers.io')

# What is DSpace?

![logo](https://wiki.duraspace.org/download/attachments/31655033/DSpace_logo_1in.png)

[DSpace](https://wiki.duraspace.org/display/DSDOC5x/Introduction) is an open source repository software package typically used for creating open access repositories for scholarly and/or published digital content. While DSpace shares some feature overlap with content management systems and document management systems, the DSpace repository software serves a specific need as a digital archives system, focused on the long-term storage, access and preservation of digital content.

This image is based on official [Java image](https://hub.docker.com/_/java/) and use [Tomcat](http://tomcat.apache.org/) to run DSpace as defined in the [installation guide](https://wiki.duraspace.org/display/DSDOC5x/Installing+DSpace).

# Usage

DSpace use [PostgreSQL](http://www.postgresql.org/) as database.

So first of all we have to create a PostgreSQL container:

```
docker run -d --name dspace_db -p 5432:5432 postgres
```

then run DSpace:

```
docker run -d --link dspace_db:postgres -p 8080:8080 1science/dspace
```

By default the database schema is created with the name `dspace` for a user `dspace` and password `dspace`, but it' possible to override this default settings :


```
docker run -d --link dspace_db:postgres \
        -e POSTGRES_SCHEMA=my_dspace \
        -e POSTGRES_USER=my_user \
        -e POSTGRES_PASSWORD=my_password \
        -p 8080:8080 1science/dspace
```

After few seconds DSpace should be accessible from:

 - JSP User Interface: http://localhost:8080/jspui
 - XML User Interface: http://localhost:8080/xmlui
 - OAI-PMH Interface: http://localhost:8080/oai/request?verb=Identify
 - REST: http://localhost:8080/rest

Note: The security constraint to tunnel request with SSL on the `/rest` endpoint has been removed, but it's very important to securize this endpoint in production through [Nginx](https://github.com/1science/docker-nginx) for example.


# Build

This project is configured as an [automated build in Dockerhub](https://hub.docker.com/r/1science/java/).

Each branch give the related image tag.  

# License

All the code contained in this repository, unless explicitly stated, is
licensed under ISC license.

A copy of the license can be found inside the [LICENSE](LICENSE) file.
