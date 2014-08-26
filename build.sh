#!/bin/bash
set -e
[ -n "$HOST" ] || HOST="http://travis-wheels.unterwaditzer.net"

package_exists() {
    pip install -q --no-install --no-deps -i "$HOST/wheels/" $PACKAGE==$VERSION
}
if package_exists; then
    echo "Package already exists."
    exit
else
    echo "Package doesn't exist yet."
fi

pip install wheel
pip wheel --no-deps --wheel-dir=./wheels/ ${PACKAGE}==${VERSION}

if [ "$(find ./wheels/* | wc -l)" != "1" ]; then
    echo "Too many files"
    find ./wheels/*
    exit 1
fi

filename="$(basename $(find ./wheels/*))"

package_url="$(curl -F "wheel=@./wheels/$filename" -F "secret_key=$SECRET_KEY" "$HOST/upload")"

case "$package_url" in
    $HOST*)
        echo "$package_url"
        ;;
    *)
        echo "Not a package URL:"
        echo "$package_url"
        exit 1
        ;;
esac
