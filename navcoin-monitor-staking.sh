#!/bin/bash
# saved as navcoin-monitor-staking.sh
# modification from original script by @givanse found on steemit.com:
# https://steemit.com/pivx/@givanse/how-to-check-if-your-pivx-wallet-has-forked
# github noted on that page is gone

set -e

cli=~/navcoin/bin/navcoin-cli
dt=`date`

function verifyStakeEnabled() {
  $cli getstakinginfo | grep -e "enabled" | sed 's/.*://' | sed 's/,.*//' | tr -d [:blank:]
}

function verifyStakeActive() {
  $cli getstakinginfo | grep -o "staking" | sed 's/.*://' | sed 's/,.*//' | tr -d [:blank:]
}

if [ `verifyStakeEnabled` != "true" ] || [ `verifyStakeActive` != "staking" ]; then
  mail -s "[nav] stake heartbeat" "root" <<EOF
    Hourly heartbeat report $dt

    Navcoin wallet is locked or otherwise not staking
EOF
fi
exit 0
