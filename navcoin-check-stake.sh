#!/bin/bash
# saved as navcoin-check-stake.sh
# modification from original script by @givanse found on steemit.com:
# https://steemit.com/pivx/@givanse/how-to-check-if-your-pivx-wallet-has-forked
# github noted on that page is gone

set -e

cli=~/navcoin/bin/navcoin-cli
dt=`date`

function verifyStakeActive() {
  $cli getstakinginfo | grep -E "enabled|staking"
}

function getStakeInfo() {
  $cli getstakereport | grep -E "Last 24H|Last All|Latest Time"
}

# "root" corresponds to /etc/aliases (place email address there) and run newaliases
# or could also just put your email address here (no quotes)
mail -s "[nav] daily stake report" "root" <<EOF
  Daily stake report for $dt

  `verifyStakeActive`

  `getStakeInfo`
EOF
exit 0
