#!/bin/bash

NEW_PATH=$GOPATH
MIXNET_PATH="$GOPATH/src/github.com/katzenpost/mixnet"

# Chnange the path in the different config files to match the current system
sed -i "s|/home/lasse/Programming/mix_net/|${NEW_PATH}/src/github.com/katzenpost/mixnet/|g" ${MIXNET_PATH}/*/*.toml
sed -i "s|/home/lasse/Programming/go_projects/|$NEW_PATH/|g" ${MIXNET_PATH}/service_provider/service_provider.toml 

# Fix permissions - 700 is required such that the go binaries execute properly
chmod -R 700 ${MIXNET_PATH}/{service_provider,provider,auth,mix*}
