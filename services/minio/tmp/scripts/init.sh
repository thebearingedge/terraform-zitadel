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
    mc admin policy create s3 "$username" "/tmp/policies/$username.json"
    # minio team says non-idempotent attachment is intended, so we're ignoring the error
    # https://github.com/minio/mc/issues/4670#issuecomment-1696053327
    # https://github.com/minio/minio/blob/fbd8dfe60fa76602c2ac882859d0341d7e95bd48/helm/minio/templates/_helper_create_user.txt#L76C1-L78
    mc admin policy attach s3 "$username" --user "$username" || true
  done
}

create_buckets
create_apps