#!/bin/bash
# saved as ltncg-check-fork.sh
# modification from original script by @givanse found on steemit.com:
# https://steemit.com/pivx/@givanse/how-to-check-if-your-pivx-wallet-has-forked
# github noted on that page is gone

set -e

cli=~/ltncg/bin/lightningcash-cli

function getLocalBlockNumber() {
  $cli getblockcount
}

function getLocalBlockHash() {
  $cli getblockhash $1
}

function getRemoteBlockHash() {
  curl -s 'https://explorer.lightningcash.tk/api/getblockhash?index='$1
}

# "root" corresponds to /etc/aliases (place email address there) and run newaliases
# or could also just put your email address here (no quotes)
function sendEmailGood() {
  mail -s "[ltncg] ltncg OK!" "root" <<EOF
  GOOD: current ltncg block is $localBlockNumber and still on main
   Local Hash:   $localBlockHash
  Remote Hash:  $remoteBlockHash
EOF
}

function sendEmailBad() {
  mail -s "[ltncg] ltncg may be forked!" "root" <<EOF
  BAD: current local ltncg block is $localBlockNumber but possible hash mismatch (ran three times):
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
  # Got tired of getting emails once things were stable, so decided to suppress
  #`sendEmailGood`
  exit 0
else
  sleep 20
  localBlockNumber=`getLocalBlockNumber`
  localBlockHash=`getLocalBlockHash $localBlockNumber`
  remoteBlockHash=`getRemoteBlockHash $localBlockNumber`
  loop=$(($loop + 1))
  echo $localBlockNumber
  echo $localBlockHash
  echo $remoteBlockHash
fi
done

`sendEmailBad`

exit 0
