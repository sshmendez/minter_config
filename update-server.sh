#/bin/bash

ssh-copy-id $1
scp melmint-install.sh $1:.

