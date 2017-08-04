#!/bin/bash    
URL=https://stage.beschleunigerphysik.de/minimum.html
PREURL=https://stage.beschleunigerphysik.de/minimum.html


docker run --shm-size=1g --rm -v "$(pwd)"/browsertime-results/minimum:/browsertime-results sitespeedio/browsertime:1.6.0 --speedIndex --video --preURL ${PREURL} ${URL}

docker run --shm-size=1g --rm -v "$(pwd)"/browsertime-results/unpreloaded:/browsertime-results sitespeedio/browsertime:1.6.0 --speedIndex --video $URL
