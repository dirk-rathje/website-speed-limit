#!/bin/bash    
URL= http://localhost:9001
# PREURL=https://jerrobs-8c83.kxcdn.com/empty/
#PREURL=https://stage.beschleunigerphysik.de/empty/
BROWSER=chrome  
#CONNECTIVITY=cable 

if [[ "$CONNECTIVITY" == "cable" || "$CONNECTIVITY" == "3g" ]] 
then BT_CONNECTIVITY="--connectivity.profile $CONNECTIVITY --connectivity.engine external" 
fi

if [[ "$CONNECTIVITY" == "dsl20" ]] 
then BT_CONNECTIVITY="--connectivity.profile custom --connectivity.downstreamKbps 20000 --connectivity.upstreamKbps 20000 --connectivity.latency 28 --connectivity.engine external"
fi

docker run --add-host="localhost:10.0.2.2" --shm-size=1g --network=$CONNECTIVITY --rm -v "$(pwd)"/browsertime-results/preloaded:/browsertime-results sitespeedio/browsertime:1.6.0 $BT_CONNECTIVITY --speedIndex --video --preURL ${PREURL} ${URL}

docker run --add-host="localhost:10.0.2.2" --shm-size=1g --network=$CONNECTIVITY --rm -v "$(pwd)"/browsertime-results/unpreloaded:/browsertime-results sitespeedio/browsertime:1.6.0 $BT_CONNECTIVITY --speedIndex --video $URL


docker run --rm -it  -p 10.0.2.15:3000:3000  -v "$(pwd)"/browsertime-results/unpreloaded:/browsertime-results sitespeedio/browsertime:1.6.0 --speedIndex --video http://192.168.178.30:9001/
