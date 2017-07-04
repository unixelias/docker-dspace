#!/usr/bin/env bash

until sudo -u postgres psql -h 127.0.0.1 -p 5432 -c '\l'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done
