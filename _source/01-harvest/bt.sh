#!/bin/bash



function bt {

URL=$1
PREURL=$2
BROWSER=chrome
CONNECTIVITY=$3
N=3

OUTPUT_PATH=/_data/1.0.0-1/01-harvested/browsertime-results/$HOSTNAME/$CONNECTIVITY

if [[ "$CONNECTIVITY" == "cable" || "$CONNECTIVITY" == "3g"  || "$CONNECTIVITY" == "3gfast" ]]
then BT_CONNECTIVITY="--connectivity.profile $CONNECTIVITY"
fi

if [[ "$CONNECTIVITY" == "dsl20" ]]
then BT_CONNECTIVITY="--connectivity.profile custom --connectivity.downstreamKbps 20000 --connectivity.upstreamKbps 20000 --connectivit
y.latency 28"
fi



docker run --shm-size=1g --privileged --network=$CONNECTIVITY --rm -v "$(pwd)"$OUTPUT_PATH/1st-page-visit:/browsertime-results sitespeedio/browsertime:1.6.0 -b $BROWSER $BT_CONNECTIVITY --output browsertime--1st-page-visit.json --iterations $N  --delay $DELAY --speedIndex --video  ${URL}

docker run --shm-size=1g --privileged --network=$CONNECTIVITY --rm -v "$(pwd)"$OUTPUT_PATH/2nd-page-visit:/browsertime-results sitespeedio/browsertime:1.6.0 -b $BROWSER $BT_CONNECTIVITY --output browsertime--2nd-page-visit.json --iterations $N --delay $DELAY --speedIndex --video --preURL ${URL} ${URL}

docker run --shm-size=1g --privileged --network=$CONNECTIVITY --rm -v "$(pwd)"$OUTPUT_PATH/2nd-site-visit:/browsertime-results sitespeedio/browsertime:1.6.0 -b $BROWSER $BT_CONNECTIVITY --output browsertime--2nd-site-visit.json --iterations $N  --delay $DELAY  --speedIndex --video --preURL ${PREURL} ${URL}


}

bt https://www.desy.de/ https://www.desy.de/impressum/ cable
bt https://www.desy.de/ https://www.desy.de/impressum/ 3g

bt https://home.cern https://home.cern/data-privacy-protection-statement cable
bt https://home.cern https://home.cern/data-privacy-protection-statement 3g

bt https://stage.beschleunigerphysik.de/ https://stage.beschleunigerphysik.de/impressum cable
bt https://stage.beschleunigerphysik.de/ https://stage.beschleunigerphysik.de/impressum 3g


