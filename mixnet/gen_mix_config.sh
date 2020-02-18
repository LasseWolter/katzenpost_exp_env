#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]
then
    echo "Usage: gen_mix_config <mix_id> <ip>"
    exit
fi

mix_id=$1
ip=$2
echo "Generating config for mix with id: $mix_id"

cp ./base_conf/mix.toml ./${mix_id}.toml
sed -i "s:mix_id:$mix_id:g" ${mix_id}.toml
sed -i "s|Addresses = \[ \"127.0.0.1:29001\"\]|Addresses = \[\"$ip\"\]|g" ${mix_id}.toml

echo "Successfully generated config for mix with id: $mix_id"
