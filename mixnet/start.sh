#!/bin/bash

if [ "$1" == "-h" ];
then
    echo "Usage $0 <bin_dir> <cliConf> <auth_toml> <provider_toml> <service_provider_toml> <mix_1_toml>"
    echo
    echo "   <bin_dir> is optional and defines a costum path which holds the go binaries"
    echo "   <cliConf> is the config file used for the experiments" 
    exit
fi
num_prov=2
num_mixes=1

# Set bin dir and config file and set default values
binDir=${1:-"$GOPATH/bin/"}
cliConf=${2:-"alice.toml"}

# set toml-files manually or use default
auth_toml=${3:-"auth/authority.toml"}
provider_toml=${4:-"provider/provider.toml"}
service_provider_toml=${5:-"service_provider/service_provider.toml"}
mix1_toml=${6:-"mix1/mix1.toml"}
mix2_toml=${7:-"mix2/mix2.toml"}
$PWD/stop.sh

echo "------------------------------"
echo "Starting up Authority"
echo "------------------------------"
    ${binDir}nonvoting -f $auth_toml -c $cliConf &
    sleep 0.5 

echo "------------------------------"
echo "Starting up $num_prov Providers"
echo "------------------------------"
    ${binDir}server -f $provider_toml -c $cliConf &
    echo "Started provider"
    sleep 0.5 
    ${binDir}server -f $service_provider_toml -c $cliConf &
    echo "Started service_provider"
    sleep 0.5 

echo "------------------------------"
echo "Starting up Mixes"
echo "------------------------------"
# Starting mixes could be done using for loop but for now it's done manually
    ${binDir}server -f $mix1_toml -c $cliConf &
    echo "Started up Mix1" 
    sleep 0.5 

    ${binDir}server -f $mix2_toml -c $cliConf &
    echo "Started up Mix2" 
    sleep 0.5 

# If we are running in the docker container then:
if [ "$1" == "/mix_net/bin/" ];
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
    /mix_net/bin/experiment -f $cliConf 

    echo "Waiting until Queue length of last node is empty.."
    grep -m 1 "Current Queue length: 0" <(tail -f /mix_net/log/mix1.log)

    echo "Copying over logfiles..."
    expName=$(cat /cliConf/expName)
    mkdir -p /mix_net/queue_outputs/$expName/ # Just in case something went wrong beforehand
    cp -r /mix_net/log/ /mix_net/queue_outputs/$expName/
    echo "Exiting.."
    # After the experiment finished, the docker container will close itself
fi
