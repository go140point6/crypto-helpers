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

localBlockNumber=`getLocalBlockNumber`
localBlockHash=`getLocalBlockHash $localBlockNumber`
remoteBlockHash=`getRemoteBlockHash $localBlockNumber`

#echo '        local block: '$localBlockNumber
#echo '   block hash local: '$localBlockHash
#echo '  block hash remote: '$remoteBlockHash

# "root" corresponds to /etc/aliases (place email address there) and run newaliases
# or could also just put your email address here (no quotes)
if [[ "$remoteBlockHash" == *"out of range"* ]]; then
  mail -s "[nav] slowpoke alert" "root" <<EOF
  The NAV blockchain explorer at chainz.crypto.info is behind the current block count

   Local block:  $localBlockNumber
EOF
exit 2
fi

if [ $localBlockHash == $remoteBlockHash ]; then
  mail -s "[nav] navcoin OK!" "root" <<EOF
  GOOD: current navcoin block is $localBlockNumber and still on main

   Local Hash:   $localBlockHash
  Remote Hash:  $remoteBlockHash
EOF
else
  mail -s "[nav] navcoin may be forked!" "root" <<EOF
  BAD: current local navcoin block is $localBlockNumber but possible hash mismatch:

   Local Hash:     $localBlockHash
  Remote Hash:    $remoteBlockHash

  Note: Run again to make sure, sometimes local is slightly behind remote so
  really not forked but hash is mismatched.
EOF
fi

exit 0
