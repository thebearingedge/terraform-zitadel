#!/bin/sh

set -eu

mc alias set s3 "$MINIO_ENDPOINT" "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD"

create_buckets() {
  [ -z "${MINIO_BUCKETS:-}" ] && return
  mc ping --count 1 --error-count 5 s3
  for bucket in $MINIO_BUCKETS; do
    mc mb --ignore-existing "s3/$bucket"
  done
}

create_apps() {
  [ -z "${MINIO_APPS:-}" ] && return
  for app in $MINIO_APPS; do
    username="$(echo "$app" | cut -d ':' -f 1)"
    password="$(echo "$app" | cut -d ':' -f 2)"
    mc admin user add s3 "$username" "$password"
  done
}

create_buckets
create_apps
