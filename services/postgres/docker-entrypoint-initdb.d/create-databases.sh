#!/bin/sh

set -eu

create_databases() {
  [ -z "$POSTGRES_DATABASES" ] && return
  for db in $POSTGRES_DATABASES; do
    psql -U "postgres" -c "create user $db with password '$db'";
    psql -U "postgres" -c "create database $db owner $db";
    psql -U "postgres" -c "grant all privileges on database $db to $db";
  done
}

create_databases
