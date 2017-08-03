#!/bin/bash    
URL=https://stage.beschleunigerphysik.de/
PREURL=https://stage.beschleunigerphysik.de/
BROWSER=chrome  
CONNECTIVITY=cable 

if [[ "$CONNECTIVITY" == "cable" || "$CONNECTIVITY" == "3g" ]] 
then BT_CONNECTIVITY="--connectivity.profile $CONNECTIVITY --connectivity.engine external" 
fi

if [[ "$CONNECTIVITY" == "dsl20" ]] 
then BT_CONNECTIVITY="--connectivity.profile custom --connectivity.downstreamKbps 20000 --connectivity.upstreamKbps 20000 --connectivity.latency 28 --connectivity.engine external"
fi


docker run --shm-size=1g --network=$CONNECTIVITY --rm -v "$(pwd)"/browsertime-results/preloaded:/browsertime-results sitespeedio/browsertime:1.6.0 $BT_CONNECTIVITY --speedIndex --video --preURL ${PREURL} ${URL}

docker run --shm-size=1g --network=$CONNECTIVITY --rm -v "$(pwd)"/browsertime-results/unpreloaded:/browsertime-results sitespeedio/browsertime:1.6.0 $BT_CONNECTIVITY --speedIndex --video $URL
