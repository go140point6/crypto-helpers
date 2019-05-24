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
   curl -# 'https://chainz.cryptoid.info/nav/api.dws?q=getblockhash&height='$1 \
   | tr -d '"'
}

blockNumber=`getBlockNumber`
localBlockHash=`getLocalBlockHash $blockNumber`
remoteBlockHash=`getRemoteBlockHash $blockNumber`

echo '            block: '$blockNumber
echo ' block hash local: '$localBlockHash
echo 'block hash remote: '$remoteBlockHash

# "root" corresponds to /etc/aliases (place email address there)
if [ $localBlockHash == $remoteBlockHash ]; then
  mail -s "navcoin OK!" "root" <<EOF
  GOOD: current navcoin block is $blockNumber and still on main

  Local Hash:   $localBlockHash
  Remote Hash:  $remoteBlockHash
EOF
else
  mail -s "navcoin may be forked!" "root" <<EOF
  BAD: current navcoin block is $blockNumber but possible hash mismatch

  Local Hash:   $localBlockHash
  Remote Hash:  $remoteBlockHash
EOF
fi

exit 0
