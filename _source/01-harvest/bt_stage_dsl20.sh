#!/bin/bash
OUTPUT_PATH=/_data/1.0.0-0/01-harvested/browsertime-results/alpha.liqw.it/
URL=https://stage.beschleunigerphysik.de/
PREURL=https://stage.beschleunigerphysik.de/impressum/
BROWSER=chrome
CONNECTIVITY=dsl20



if [[ "$CONNECTIVITY" == "cable" || "$CONNECTIVITY" == "3g" ]]
then BT_CONNECTIVITY="--connectivity.profile $CONNECTIVITY --connectivity.engine external"
fi

if [[ "$CONNECTIVITY" == "dsl20" ]]
then BT_CONNECTIVITY="--connectivity.profile custom --connectivity.downstreamKbps 20000 --connectivity.upstreamKbps 20000 --connectivity.latency 28 --connectivity.engine external"
fi

docker run --shm-size=1g --rm -v "$(pwd)"/browsertime-results:$OUTPUT_PATH sitespeedio/browsertime:1.6.0 $BT_CONNECTIVITY --output browsertime-preloaded.json --speedIndex --video --preURL ${URL} ${URL}

docker run --shm-size=1g --rm -v "$(pwd)"/browsertime-results:$OUTPUT_PATH sitespeedio/browsertime:1.6.0 $BT_CONNECTIVITY --output browsertime-unpreloaded.json  --speedIndex $URL

docker run --shm-size=1g --network=$CONNECTIVITY --rm -v "$(pwd)"/browsertime-results:$OUTPUT_PATH sitespeedio/browsertime:1.6.0 $BT_CONNECTIVITY --output browsertime-service-worker.json  --speedIndex --preURL ${PREURL} ${URL}
