#!/bin/sh

set -e

cd /myapp

make clean
make docker_all
