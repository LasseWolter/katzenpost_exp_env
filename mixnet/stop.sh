#!/bin/bash

echo "Stopping all components of the mixnet"
sudo killall server panda spool_server nonvoting -9

sleep 1
echo "To check if things were stopped. Here are the current processes:"
ps -a 
