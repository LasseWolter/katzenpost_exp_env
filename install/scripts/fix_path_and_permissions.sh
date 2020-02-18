#!/bin/bash

NEW_PATH=$GOPATH
MIXNET_PATH="$GOPATH/src/github.com/katzenpost/mixnet"

# Chnange the path in the different config files to match the current system
sed -i "s|/home/lasse/go/src/github.com/katzenpost/mixnet/|${NEW_PATH}/src/github.com/katzenpost/mixnet/|g" ${MIXNET_PATH}/*/*.toml ${MIXNET_PATH}/*.toml
sed -i "s|/home/lasse/go/|$NEW_PATH/|g" ${MIXNET_PATH}/service_provider/service_provider.toml 

# Fix permissions - 700 is required such that the go binaries execute properly
chmod -R 700 ${MIXNET_PATH}/{service_provider,provider,auth,mix*}
