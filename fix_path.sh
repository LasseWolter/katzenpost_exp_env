#!/bin/bash

NEW_PATH=$GOPATH
MIXNET_PATH="$GOPATH/src/github.com/katzenpost/mixnet"

sed -i "s|/home/lasse/Programming/mix_net/|${NEW_PATH}/src/github.com/katzenpost/mixnet/|g" ${MIXNET_PATH}/*/*.toml
sed -i "s|/home/lasse/Programming/go_projects/|$NEW_PATH/|g" ${MIXNET_PATH}/service_provider/service_provider.toml 
