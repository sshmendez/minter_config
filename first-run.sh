#!/bin/bash

git clone https://github.com/sshmendez/minter_config;
cd minter_config;

source melmint-install.sh
source open-windows.sh


./melmint-install --debian --rust


melwalletd --wallet-dir ~/.themelio > melwalletd.log 2>&1 &;
sleep 2; curl -s localhost:11773/wallets/w;

melminter --backup-wallet w > melminter.log 2>&1 &;

echo "Installing the minter is complete"