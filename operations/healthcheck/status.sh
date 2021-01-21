#!/bin/sh
curl --location --write-out "%{http_code}\n" --silent --insecure --output /dev/null "$1"
