#!/bin/sh

set -eu

healthcheck() {
  for db in $POSTGRES_DATABASES; do
    psql -U "$db" -d "$db" -c "select 1"
  done
}

healthcheck