#!/bin/bash

katz_dir=$GOPATH/src/github.com/katzenpost

# Install binaries for authority, server and catshadow client
go install $katz_dir/daemons/authority/nonvoting
go install $katz_dir/daemons/server
go install $katz_dir/catshadow/cmd

# For the following two go executables it's a bit more difficult:
# we want to install the binaries under a name that's different to 
# the directory the main.go file is in
# Since go's install command has no such functionality we use
# 'go build' and then move the binary to the correct folder
go build -o spool_server_tmp $katz_dir/memspool/server
mv spool_server_tmp $GOPATH/bin/spool_server

go build -o panda_tmp $katz_dir/panda/server
mv panda_tmp $GOPATH/bin/panda

