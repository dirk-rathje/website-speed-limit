#!/bin/bash    
URL=http://192.168.178.29:8000
PREURL=http://192.168.178.29:8000


docker run --shm-size=1g --rm -v "$(pwd)"/browsertime-results/minimum-local/unreploaded:/browsertime-results sitespeedio/browsertime:1.6.0 --speedIndex --video --preURL ${PREURL} ${URL}

docker run --shm-size=1g --rm -v "$(pwd)"/browsertime-results/minimum-local/preloaded:/browsertime-results sitespeedio/browsertime:1.6.0 --speedIndex --video $URL
