#!/bin/sh
set -e
pip wheel --no-deps --wheel-dir=./wheels/ ${PACKAGE}==${VERSION}

if [ "$(find ./wheels/* | wc -l)" != "1" ]; then
    echo "Too many files"
    find ./wheels/*
    exit 1
fi

filename="$(basename $(find ./wheels/*))"
[ -n "$HOST" ] || HOST="http://travis-wheels.unterwaditzer.net"

curl -F "wheel=@./wheels/$filename" -F "secret_key=$SECRET_KEY" "$HOST/upload"
