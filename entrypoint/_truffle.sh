#!/bin/bash

mkdir -p $HOME/solidity-output/repo/bin
touch  $HOME/solidity-output/repo/bin/.gitkeep

git -c advice.detachedHead=false checkout FETCH_HEAD
sudo npm install -g truffle@5.1.43 
# 
truffle@5.1.43 postinstall $HOME/solidity-output/repo/node_modules/truffle
node ./scripts/postinstall.js

core-js@2.6.11 postinstall $HOME/solidity-output/repo/node_modules/core-js

node -e "try{require('./postinstall')}catch(e){}"
npx truffle version
npx truffle compile
