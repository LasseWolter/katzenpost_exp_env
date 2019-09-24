#!/bin/bash
root="/home/lasse/Programming/go_projects/src/github.com/katzenpost/"

echo "Installing go binaries..."
go install ${root}daemons/server
go install ${root}daemons/authority/nonvoting
go install ${root}catshadow/cmd
go install ${root}catshadow/experiment
echo "...finished installing binaries."
echo "------------------------------"

./start.sh
