[private]
default:
  @just --list --unsorted --list-heading '' --list-prefix ''

up *args:
  docker compose up --build --detach {{args}}

down *args:
  docker compose down --remove-orphans {{args}}

certs:
  mkcert -cert-file certs/tls.crt -key-file certs/tls.key "$DOMAIN_NAME" "*.$DOMAIN_NAME"
  cat certs/tls.crt certs/tls.key > certs/tls.pem
