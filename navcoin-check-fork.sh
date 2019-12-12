#!/bin/bash
# saved as navcoin-check-fork.sh
# modification from original script by @givanse found on steemit.com:
# https://steemit.com/pivx/@givanse/how-to-check-if-your-pivx-wallet-has-forked
# github noted on that page is gone

set -e

cli=~/navcoin/bin/navcoin-cli

function getLocalBlockNumber() {
  $cli getinfo | grep blocks | sed "s/.*: \([0-9]\+\).*/\1/"
}

function getLocalBlockHash() {
  $cli getblockhash $1
}

function getRemoteBlockHash() {
   curl -s 'https://chainz.cryptoid.info/nav/api.dws?q=getblockhash&height='$1 | tr -d '"'
}

# "root" corresponds to /etc/aliases (place email address there) and run newaliases
# or could also just put your email address here (no quotes)
function sendEmailGood() {
  mail -s "[nav] navcoin OK!" "root" <<EOF
  GOOD: current navcoin block is $localBlockNumber and still on main

        eLoop:            $eloop
   Local Hash:   $localBlockHash
  Remote Hash:  $remoteBlockHash
EOF
}

function sendEmailBad() {
  mail -s "[nav] navcoin may be forked!" "root" <<EOF
  BAD: current local navcoin block is $localBlockNumber but possible hash mismatch (ran three times):

   Local Hash:     $localBlockHash
  Remote Hash:    $remoteBlockHash
EOF
}

localBlockNumber=`getLocalBlockNumber`
localBlockHash=`getLocalBlockHash $localBlockNumber`
remoteBlockHash=`getRemoteBlockHash $localBlockNumber`
#echo $localBlockNumber
#echo $localBlockHash
#echo $remoteBlockHash

loop=0
while [ $loop -lt 3 ]; do
if [[ "$localBlockHash" == "$remoteBlockHash" ]]; then
  eloop=$loop
  loop=99
  `sendEmailGood`
  exit 0
else
  sleep 180
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
