#!/bin/bash
# saved as neblio-monitor-staking.sh
# modification from original script by @givanse found on steemit.com:
# https://steemit.com/pivx/@givanse/how-to-check-if-your-pivx-wallet-has-forked
# github noted on that page is gone

set -e

cli=~/neblio/bin/nebliod
dt=`date`

function verifyStakeEnabled() {
  $cli getstakinginfo | grep -e "enabled" | sed 's/.*://' | sed 's/,.*//' | tr -d [:blank:]
}

function verifyStakeActive() {
  $cli getstakinginfo | grep -e "staking" | sed 's/.*://' | sed 's/,.*//' | tr -d [:blank:]
}

if [ `verifyStakeEnabled` != "true" ] || [ `verifyStakeActive` != "true" ]; then
  mail -s "[nebl] stake heartbeat" "root" <<EOF
    Hourly heartbeat report $dt

    Neblio wallet is locked or otherwise not staking
EOF
fi
exit 0
