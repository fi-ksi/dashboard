#!/bin/bash

export LC_ALL=C.UTF-8

echo -e "Content-type: text/html\n"

OUTPUT+=$(cd .. && ./kleobis-deploy.sh 2>&1)$'\n\n'
echo "$OUTPUT" | mail "ksi-admin@fi.muni.cz" -s "[ksi-monitoring] Deploy status"
