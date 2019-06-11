#!/bin/bash
# saved as navcoin-check-stake.sh

# note this script requires jq
# sudo apt-get install jq

set -e

cli=~/navcoin/bin/navcoin-cli
dt=`date`

function verifyStakeActive() {
  $cli getstakinginfo
}

function getStakeInfo() {
  $cli getstakereport
}

enabled="$($cli getstakinginfo | jq -r '.enabled')"
staking="$($cli getstakinginfo | jq -r '.staking')"

day="$($cli getstakereport | jq -r '.["Last 24H"]')"
all="$($cli getstakereport | jq -r '.["Last All"]')"

mail -s "[nav] daily stake report" "root" <<EOF
  Daily stake report for $dt

  Enabled: $enabled
  Staking: $staking

  $day NAV earned in last 24H
  $all NAV earned total
EOF
exit 0
