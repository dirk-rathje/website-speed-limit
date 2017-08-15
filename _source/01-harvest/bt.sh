#!/bin/bash



function bt {

URL=$1
PREURL=$2
BROWSER=chrome
CONNECTIVITY=$3
N=1

OUTPUT_PATH=/_data/1.0.0-1/01-harvested/browsertime-results/$HOSTNAME/$CONNECTIVITY

if [[ "$CONNECTIVITY" == "cable" || "$CONNECTIVITY" == "3g" ]]
then BT_CONNECTIVITY="--connectivity.profile $CONNECTIVITY"
fi

if [[ "$CONNECTIVITY" == "cable" ]]
then BT_VIEWPORT="--viewPort 1280x800"
fi

if [[ "$CONNECTIVITY" == "3g" ]]
then BT_VIEWPORT="--viewPort 360x640"
fi

#BT_VIEWPORT="--viewPort 1280x800"


if [[ "$CONNECTIVITY" == "dsl20" ]]
then BT_CONNECTIVITY="--connectivity.profile custom --connectivity.downstreamKbps 20000 --connectivity.upstreamKbps 20000 --connectivit
y.latency 28"
fi

echo "******* "
echo "******* ******* ******* ******* ******* ******* ******* ******* "
echo "******* 1st-site-visit"
echo "******* ${URL}"
echo "******* $CONNECTIVITY"
echo "******* "

docker run --shm-size=1g --privileged --network=$CONNECTIVITY --rm -v "$(pwd)"$OUTPUT_PATH/1st-site-visit:/browsertime-results sitespeedio/browsertime:1.6.0 -b $BROWSER $BT_VIEWPORT $BT_CONNECTIVITY  --iterations $N  --delay $DELAY --speedIndex --video  ${URL}


echo "******* "
echo "******* ******* ******* ******* ******* ******* ******* ******* "
echo "******* 2nd-page-visit"
echo "******* ${URL}"
echo "******* $CONNECTIVITY"
echo "******* "


docker run --shm-size=1g --privileged --network=$CONNECTIVITY --rm -v "$(pwd)"$OUTPUT_PATH/2nd-page-visit:/browsertime-results sitespeedio/browsertime:1.6.0 -b $BROWSER $BT_VIEWPORT  $BT_CONNECTIVITY --iterations $N --delay $DELAY --speedIndex --video --preURL ${URL} ${URL}




echo "******* "
echo "******* ******* ******* ******* ******* ******* ******* ******* "
echo "******* 2nd-site-visit"
echo "******* ${URL}"
echo "******* $CONNECTIVITY"
echo "******* "


docker run --shm-size=1g --privileged --network=$CONNECTIVITY --rm -v "$(pwd)"$OUTPUT_PATH/2nd-site-visit:/browsertime-results sitespeedio/browsertime:1.6.0 -b $BROWSER $BT_VIEWPORT  $BT_CONNECTIVITY --iterations $N  --delay $DELAY  --speedIndex --video --preURL ${PREURL} ${URL}


}

bt https://stage.beschleunigerphysik.de/empty/ https://stage.beschleunigerphysik.de/empty/ cable
bt https://stage.beschleunigerphysik.de/empty/ https://stage.beschleunigerphysik.de/empty/ 3g

bt https://www.google.com/ https://www.google.com/ cable
bt https://www.google.com/ https://www.google.de/intl/de/policies/privacy/ 3g


bt https://www.desy.de/ https://www.desy.de/impressum/ cable
bt https://www.desy.de/ https://www.desy.de/impressum/ 3g

bt https://home.cern https://home.cern/data-privacy-protection-statement cable
bt https://home.cern https://home.cern/data-privacy-protection-statement 3g

bt https://stage.beschleunigerphysik.de/ https://stage.beschleunigerphysik.de/impressum cable
bt https://stage.beschleunigerphysik.de/ https://stage.beschleunigerphysik.de/impressum 3g


