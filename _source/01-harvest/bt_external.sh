#!/bin/bash
URL=https://stage.beschleunigerphysik.de/
PREURL=https://stage.beschleunigerphysik.de/impressum
BROWSER=chrome
CONNECTIVITY=3g
DELAY=3000

if [[ "$CONNECTIVITY" == "cable" || "$CONNECTIVITY" == "3g" ]]
then BT_CONNECTIVITY="--connectivity.profile $CONNECTIVITY --connectivity.engine external"
fi

if [[ "$CONNECTIVITY" == "dsl20" ]]
then BT_CONNECTIVITY="--connectivity.profile custom --connectivity.downstreamKbps 20000 --connectivity.upstreamKbps 20000 --connectivit
y.latency 28 --connectivity.engine external"
fi

docker run --shm-size=1g --network=$CONNECTIVITY --rm -v "$(pwd)"/browsertime-results:/browsertime-results sitespeedio/browsertime:1.6.0 $BT_CONNECTIVITY --output browsertime-preloaded.json --delay $DELAY --speedIndex --video --preURL  ${URL} ${URL}

docker run --shm-size=1g --network=$CONNECTIVITY --rm -v "$(pwd)"/browsertime-results:/browsertime-results sitespeedio/browsertime:1.6.0 $BT_CONNECTIVITY --output browsertime-unpreloaded.json --delay $DELAY   --speedIndex --video $URL

docker run --shm-size=1g --network=$CONNECTIVITY --rm -v "$(pwd)"/browsertime-results:/browsertime-results sitespeedio/browsertime:1.6.0 $BT_CONNECTIVITY --output browsertime-sw.json --delay $DELAY  --speedIndex --video --preURL ${PREURL} $URL

