#!/bin/bash
echo "Unpack dependencies..."
cat dep/part_dep.* > dep.zip
unzip dep.zip -d $GOPATH/src

echo "Installing go binaries..."
# Fixing path means that the path in the different config files is changed to match
# the current system - otherwise the start.sh file won't work
./scripts/fix_path_and_permissions.sh
./scripts/install_go_binaries.sh
