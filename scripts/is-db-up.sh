#!/usr/bin/env bash

until psql -h 127.0.0.1 -p 5432 -U "postgres" -c '\l'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done
