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

function getLocalBlockHash() {
  $cli getblockhash $1
}

function getRemoteBlockHash() {
   curl -s 'https://explorer.nebl.io/api/getblockhash?index='$1
}

# "root" corresponds to /etc/aliases (place email address there) and run newaliases
# or could also just put your email address here (no quotes)
function sendEmailGood() {
  mail -s "[nebl] neblio OK!" "root" <<EOF
  GOOD: current neblio block is $localBlockNumber and still on main

   Local Hash:   $localBlockHash
  Remote Hash:  $remoteBlockHash
EOF
}

function sendEmailBad() {
  mail -s "[nebl] neblio may be forked!" "root" <<EOF
  BAD: current local neblio block is $localBlockNumber but possible hash mismatch (ran three times):

   Local Hash:     $localBlockHash
  Remote Hash:    $remoteBlockHash
EOF
}

localBlockNumber=`getLocalBlockNumber`
localBlockHash=`getLocalBlockHash $localBlockNumber`
remoteBlockHash=`getRemoteBlockHash $remoteBlockNumber`
#echo $localBlockNumber
#echo $localBlockHash
#echo $remoteBlockHash

loop=0
while [ $loop -lt 3 ]; do
if [[ "$localBlockHash" == "$remoteBlockHash" ]]; then
  `sendEmailGood`
  loop=99
  exit 0
else
  sleep 20
  localBlockNumber=`getLocalBlockNumber`
  localBlockHash=`getLocalBlockHash $localBlockNumber`
  remoteBlockHash=`getRemoteBlockHash $localBlockNumber`
  loop=$(($loop + 1))
  #echo $localBlockNumber
  #echo $localBlockHash
  #echo $remoteBlockHash
  
fi
done

`sendEmailBad`

exit 0
