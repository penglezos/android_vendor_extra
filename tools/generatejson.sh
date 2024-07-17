#!/bin/bash
#
# Copyright (C) 2023 ivanmeler <i_ivan@windowslive.com>
# Copyright (C) 2024 Panagiotis Englezos <panagiotisegl@gmail.com>
#
# Android ROM .json file generator 
#
# Usage: ./generatejson.sh <ota zip>
#

if [ -z "$1" ] ; then
    echo "Usage: $0 <ota zip>"
    exit 1
fi

ROM="$1"

METADATA=$(unzip -p "$ROM" META-INF/com/android/metadata)
SDK_LEVEL=$(echo "$METADATA" | grep post-sdk-level | cut -f2 -d '=')
TIMESTAMP=$(echo "$METADATA" | grep post-timestamp | cut -f2 -d '=')

FILENAME=$(basename $ROM)
DEVICE=$(echo $FILENAME | cut -f5 -d '-' | cut -f1 -d".")
ROMTYPE=$(echo $FILENAME | cut -f4 -d '-')
DATE=$(echo $FILENAME | cut -f3 -d '-')
ID=$(echo ${TIMESTAMP}${DEVICE}${SDK_LEVEL} | sha256sum | cut -f 1 -d ' ')
SIZE=$(du -b $ROM | cut -f1 -d '	')
TYPE=$(echo $FILENAME | cut -f4 -d '-')
VERSION=$(echo $FILENAME | cut -f2 -d '-')
RELASE_TAG=lineage-${VERSION}-${DATE}-${ROMTYPE}-${DEVICE}

URL="https://github.com/penglezos/device_xiaomi_raphael/releases/download/${RELASE_TAG}/${FILENAME}"

response=$(jq -n --arg datetime $TIMESTAMP \
        --arg filename $FILENAME \
        --arg id $ID \
        --arg romtype $ROMTYPE \
        --arg size $SIZE \
        --arg url $URL \
        --arg version $VERSION \
        '$ARGS.named'
)
wrapped_response=$(jq -n --argjson response "[$response]" '$ARGS.named')
echo "$wrapped_response" > ../OTA/$VERSION/$DEVICE.json

while true; do
    read -p "Do you want to proceed? (yes/no) " yn
    case $yn in 
        yes|y ) 
        git add ../OTA/$VERSION/$DEVICE.json
        git commit -m "Update json file for $DEVICE-$VERSION-${DATE}"
        git push -f
        echo Updated .json file is uploaded successfully!
        break;;

	    no|n ) 
        echo .json file is generated but NOT uploaded.;
		exit;;

	    * ) 
        echo Invalid response;;
    esac
done
