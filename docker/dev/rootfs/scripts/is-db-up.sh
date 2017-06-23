#!/usr/bin/env bash

until sudo -u postgres psql -c '\l'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done
