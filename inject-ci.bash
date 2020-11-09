#!/bin/bash
# SPDX-License-Identifier: EPL-2.0
# version: v0.1.0

set -o errexit

# export env
export CI=''
export LC_ALL=C

# ensure CI enviornment
yarn --version || exit 0

# start testing eth-saddle for CI purposes 
npm install --global eth-saddle

# install the repo
yarn

# CI dependency injection
yarn add --dev "https://github.com/sc-forks/solidity-coverage.git#$COMMIT_REF"

# load package 
cat package.json

# run commands 
yarn run coverage
