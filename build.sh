#!/bin/sh
set -e
[ -n "$HOST" ] || HOST="http://travis-wheels.unterwaditzer.net"

package_exists() {
    curl "$HOST/wheels/" | grep "$PACKAGE-$VERSION" | grep "$(echo $TRAVIS_PYTHON_VERSION | tr -d .)"
}
if package_exists; then
    echo "Package already exists."
    exit
fi

pip install wheel
pip wheel --no-deps --wheel-dir=./wheels/ ${PACKAGE}==${VERSION}

if [ "$(find ./wheels/* | wc -l)" != "1" ]; then
    echo "Too many files"
    find ./wheels/*
    exit 1
fi

filename="$(basename $(find ./wheels/*))"

curl -F "wheel=@./wheels/$filename" -F "secret_key=$SECRET_KEY" "$HOST/upload"
