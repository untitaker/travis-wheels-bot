#!/bin/sh
set -e
pip wheel --wheel-dir=./wheels/ ${PACKAGE}==${VERSION}

if [ "$(find ./wheels/* | wc -l)" != "1" ]; then
    echo "Too many files"
    find ./wheels/*
    exit 1
fi

filename="$(basename $(find ./wheels/*))"

curl -F "wheel=@./wheels/$filename" -u $SERVER_USER:$SERVER_PASSWORD \
    http://travis-wheels.unterwaditzer.net/upload
