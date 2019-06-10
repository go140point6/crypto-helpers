#!/bin/bash
# saved as neblio-check-stake.sh

# note this script requires jq
# sudo apt-get install jq

set -e

cli=~/neblio/bin/nebliod
dt=`date`
# Set the time period you will run this here (i.e. 24H)
period="24H"

function getBlockCount() {
  $cli getblockcount
}

function getCurrentHash() {
  $cli getblockhash $currentBlock
}

function listSinceBlock() {
  $cli listsinceblock $(<~/neblio/bin/last.hash)
}

function getStakingInfo() {
  $cli getstakinginfo
}

# make sure a file last.hash exists (likely only run the first time)
if test -f ~/neblio/bin/last.hash; then
  lastBlockHash=$(<~/neblio/bin/last.hash)
else
  currentBlock=`getBlockCount`
  lastBlockHash=`getCurrentHash`
  echo $lastBlockHash > ~/neblio/bin/last.hash
fi

# get currentHash based on hash in last.hash file
currentHash=$(listSinceBlock | jq -r '.lastblock')

j=0
sum=0
# loop through and sum the total of transactions (multiple stakes over a longer period, for instance)
for i in $(jq -r '.transactions[]? | select(.category=="generate").amount' <<< `listSinceBlock`); do
  sum=$(echo $i + $j | bc)
  j=$sum
done

# email notificaiton
# "root" corresponds to /etc/aliases (place email address there) and run newaliases
# or could also just put your email address here (no quotes)
mail -s "[nebl] $period stake report" "root" <<EOF
  stake report for $dt

  $sum NEBL earned in last $period

  `getStakingInfo`
EOF

# take the current hash and store in last.hash for next run
echo $currentHash > ~/neblio/bin/last.hash

exit
