#!/bin/bash
# saved as pivx-check-fork.sh
# modification from original script by @givanse found on steemit.com:
# https://steemit.com/pivx/@givanse/how-to-check-if-your-pivx-wallet-has-forked
# github noted on that page is gone

set -e

pivxcli=~/pivx/bin/pivx-cli

function getLocalBlockNumber() {
  $pivxcli getinfo | grep blocks | sed "s/.*: \([0-9]\+\).*/\1/"
}

function getRemoteBlockNumber() {
  curl -s 'https://pivx.ccore.online/api/getblockcount'
  # need to slow calls to ccore api
  sleep 1
}

function getLocalBlockHash() {
  $pivxcli getblockhash $1
  # extra sleep to slow calls to ccore api
  sleep 1
}

function getRemoteBlockHash() {
   curl -s 'https://pivx.ccore.online/api/getblockhash?index='$1
}

localBlockNumber=`getLocalBlockNumber`
remoteBlockNumber=`getRemoteBlockNumber`
localBlockHash=`getLocalBlockHash $localBlockNumber`
remoteBlockHash=`getRemoteBlockHash $remoteBlockNumber`

#echo '        local block: '$localBlockNumber
#echo '       remote block: '$remoteBlockNumber
#echo '   block hash local: '$localBlockHash
#echo '  block hash remote: '$remoteBlockHash

# "root" corresponds to /etc/aliases (place email address there) and run newaliases
# or could also just put your email address here (no quotes)
if [[ "$remoteBlockHash" == *"data error"* ]]; then
  mail -s "[pivx] slowpoke alert" "root" <<EOF
  The PIVX blockchain explorer at pivx.ccore.online is behind the current block count

   Local block:  $localBlockNumber
   Remote block: $remoteBlockNumber
EOF
exit 2
fi

if [ $localBlockHash == $remoteBlockHash ]; then
  mail -s "[pivx] pivx OK!" "root" <<EOF
  GOOD: current pivx block is $localBlockNumber and still on main

   Local Hash:   $localBlockHash
  Remote Hash:  $remoteBlockHash
EOF
else
  mail -s "[pivx] pivx may be forked!" "root" <<EOF
  BAD: current local pivx block is $localBlockNumber but possible hash mismatch:

 Remote Block:  $remoteBlockNumber
   Local Hash:     $localBlockHash
  Remote Hash:    $remoteBlockHash
EOF
fi

exit 0
