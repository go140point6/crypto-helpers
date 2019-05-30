#!/bin/bash
# saved as neblio-check-fork.sh
# modification from original script by @givanse found on steemit.com:
# https://steemit.com/pivx/@givanse/how-to-check-if-your-pivx-wallet-has-forked
# github noted on that page is gone

set -e

cli=~/neblio/bin/nebliod

function getLocalBlockNumber() {
  $cli getinfo | grep blocks | sed "s/.*: \([0-9]\+\).*/\1/"
}

function getRemoteBlockNumber() {
  curl -s 'https://explorer.nebl.io/api/getblockcount'
  # need to slow calls to ccore api
  sleep 1
}

function getLocalBlockHash() {
  $cli getblockhash $1
  # extra sleep to slow calls to ccore api
  sleep 1
}

function getRemoteBlockHash() {
   curl -s 'https://explorer.nebl.io/api/getblockhash?index='$1
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
if [[ "$remoteBlockHash" == *"error"* ]]; then
  mail -s "[nebl] slowpoke alert" "root" <<EOF
  The NEBL blockchain explorer at explorer.nebl.io is behind the current block count

   Local block:  $localBlockNumber
   Remote block: $remoteBlockNumber
EOF
exit 2
fi

if [ $localBlockHash == $remoteBlockHash ]; then
  mail -s "[nebl] neblio OK!" "root" <<EOF
  GOOD: current neblio block is $localBlockNumber and still on main

   Local Hash:   $localBlockHash
  Remote Hash:  $remoteBlockHash
EOF
else
  mail -s "[nebl] neblio may be forked!" "root" <<EOF
  BAD: current local neblio block is $localBlockNumber but possible hash mismatch:

 Remote Block:  $remoteBlockNumber
   Local Hash:     $localBlockHash
  Remote Hash:    $remoteBlockHash

  Note: Run again to make sure, sometimes local is slightly behind remote so
  really not forked but hash is mismatched.
EOF
fi

exit 0
