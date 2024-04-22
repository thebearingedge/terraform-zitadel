#!/bin/sh

set -eu

healthcheck() {
  mc alias set s3 "$MINIO_ENDPOINT" "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD"
  mc ping --count 1 --error-count 5 s3
}

healthcheck