#!/bin/bash
git -c advice.detachedHead=false checkout FETCH_HEAD
node ./scripts/postinstall.js
node -e "try{require('./postinstall')}catch(e){}"
