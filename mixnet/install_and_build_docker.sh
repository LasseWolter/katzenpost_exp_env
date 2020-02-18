#!/bin/bash
root="$GOPATH/src/github.com/katzenpost/"

# Make sure no servers are running locally
echo "Stopping possible server instances running locally before build"
./stop.sh

# Clean up the environment by deleting already existing dbs, statefiles, etc.
echo "Cleaning log-files and dbs before build"
source ./cleanEnv.sh
echo "Installing go binaries..."
go install ${root}daemons/server
go install ${root}daemons/authority/nonvoting
go install ${root}catshadow/cmd
go install ${root}catshadow/experiment
echo "...finished installing binaries."
echo "------------------------------"

printf "copying most recent go binaries for \n\t-server\n\t-nonvoting\n\t-panda\n\t-spool_server\n\t-cmd\n\t-experiment\n\n"
cp -v $GOPATH/bin/{server,nonvoting,panda,spool_server,experiment} ./bin

printf "\nStart buiding docker container (using sudo)...\n"
sudo docker build -t mix_net .
printf "Finished building docker container.\n\n"
