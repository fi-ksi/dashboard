#!/bin/bash
set -xuo pipefail
cd "$(dirname "$(realpath "$0")")"

git fetch origin
git reset --hard origin/master

make clean
# Run as www-data to prevent vulnerabilities possible spread
sudo -Hu www-data make all -j 1 && # don't use higher -j than 1, otherwise race condition
curl --silent https://status.ahlava.cz/api/push/u44pwYohQ2 > /dev/null
