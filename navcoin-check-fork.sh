#!/bin/bash
# saved as navcoin-check-fork.sh
# modification from original script by @givanse found on steemit.com:
# https://steemit.com/pivx/@givanse/how-to-check-if-your-pivx-wallet-has-forked
# github noted on that page is gone

set -e

navcoincli=~/navcoin/bin/navcoin-cli

function getBlockNumber() {
  $navcoincli getinfo | grep blocks | sed "s/.*: \([0-9]\+\).*/\1/"
}

function getLocalBlockHash() {
  $navcoincli getblockhash $1
}

function getRemoteBlockHash() {
#  curl -# 'https://pivx.ccore.online/api/getblockhash?index='$1
   curl -# 'https://chainz.cryptoid.info/nav/api.dws?q=getblockhash&height='$1 | tr -d '"'
}

blockNumber=`getBlockNumber`
localBlockHash=`getLocalBlockHash $blockNumber`
remoteBlockHash=`getRemoteBlockHash $blockNumber`

echo '            block: '$blockNumber
echo ' block hash local: '$localBlockHash
echo 'block hash remote: '$remoteBlockHash

if [ $localBlockHash == $remoteBlockHash ]; then
  echo 'GOOD: still on main'
else
  echo 'BAD: you are on a fork, got to re-sync'
fi

exit 0