#!/bin/sh
pip wheel --wheel-dir=./wheels/ ${PACKAGE}==${VERSION}

curl --upload-file ./wheels/* -u $SERVER_USER:$SERVER_PASSWORD http://travis-wheels.unterwaditzer.net/upload
