#!/bin/bash

num_prov=2
num_mixes=1

binDir="$GOPATH/bin/"

./stop.sh

echo "------------------------------"
echo "Starting up Authority"
echo "------------------------------"
    ${binDir}nonvoting -f auth/authority.toml &
    sleep 0.5 

echo "------------------------------"
echo "Starting up $num_prov Providers"
echo "------------------------------"
    ${binDir}server -f provider/provider.toml &
    echo "Started provider"
    sleep 0.5 
    ${binDir}server -f service_provider/service_provider.toml &
    echo "Started service_provider"
    sleep 0.5 

echo "------------------------------"
echo "Starting up $num_mixes Mixes"
echo "------------------------------"
for i in `seq 1 $num_mixes`
do
    ${binDir}server -f mix$i/mix$i.toml &
    echo "Started up Mix $i"
    sleep 0.5 
done
