#!/bin/bash

if [ "$1" == "-h" ];
then
    echo "Usage $0 <rootDir> <bin_dir> <expConf>"
    echo
    echo "   <root_Dir> defines the root dir of all mixnet config files (default: ./)"
    echo "   <bin_dir> defines a costum path which holds the go binaries (default: \$GOPATH/bin) "
    echo "   <expConf> is the config file used for the experiments (default: config.toml)" 
    exit
fi

# Num of mixes needs to be set such that the for loop iterates over all mixes
num_mixes=1

# Set bin dir and config file and set default values
rootDir=${1:-"./"}
binDir=${2:-"$GOPATH/bin/"}
expConf=${3:-"config.toml"}


docker_prefix=""
if [ "$1" == "/mix_net/" ];
then
    docker_prefix="docker_"
fi

# set toml-files manually or use default
auth_toml="auth/${docker_prefix}authority.toml"
provider_toml="provider/${docker_prefix}provider.toml"
service_provider_toml="service_provider/${docker_prefix}service_provider.toml"

$PWD/stop.sh

echo "------------------------------"
echo "Starting up Authority"
echo "------------------------------"
    ${binDir}nonvoting -f $rootDir$auth_toml -c $expConf &
    sleep 0.5 

echo "------------------------------"
echo "Starting up Providers"
echo "------------------------------"
    ${binDir}server -f $rootDir$provider_toml -c $expConf &
    echo "Started provider"
    sleep 0.5 
    ${binDir}server -f $rootDir$service_provider_toml -c $expConf &
    echo "Started service_provider"
    sleep 0.5 

echo "------------------------------"
echo "Starting up Mixes"
echo "------------------------------"
for i in `seq 1 $num_mixes`
do
    ${binDir}server -f ${rootDir}mix$i/${docker_prefix}mix$i.toml -c $expConf &
    echo "Started up Mix $i"
    sleep 0.5 
done

# If we are running in the docker container then:
if [ "$1" == "/mix_net/" ];
then 
    # Wait until the first Handshake completes (+a few secs) - this means the provider is connencted to the mix
    # We wait for 22 handshakes because that seems to be what is needed: 1 incomming, 1 outgoing
    echo "Waiting for Handshakes between servers to complete..."
    res=$(grep -m 1 -E "Handshake completed|is wildly disjoint from" <(tail -f /mix_net/log/provider.log))
    # Check if this weird error (no solution in catshadow yet) happened and return exit code 1
    if [[ $res == *"is wildly disjoint from"* ]]; then
        exit 1
    fi
    sleep 10 
    /mix_net/bin/experiment -f $expConf 

    echo "Waiting until Queue length of last node is empty.."
    grep -m 1 "Current Queue length: 0" <(tail -f /mix_net/log/mix1.log)

    echo "Copying over logfiles..."
    expName=$(cat /cliConf/expName)
    mkdir -p /mix_net/queue_outputs/$expName/ # Just in case something went wrong beforehand
    cp -r /mix_net/log/ /mix_net/queue_outputs/$expName/
    echo "Exiting.."
    # After the experiment finished, the docker container will close itself
fi
