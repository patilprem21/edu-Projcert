#!/bin/bash
set -e
CONTAINER="projcert_app"

if docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER$"; then
  docker stop $CONTAINER || true
  docker rm $CONTAINER || true
fi

docker image prune -f
