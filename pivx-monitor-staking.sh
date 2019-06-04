#!/bin/bash
# saved as pivx-monitor-staking.sh
# modification from original script by @givanse found on steemit.com:
# https://steemit.com/pivx/@givanse/how-to-check-if-your-pivx-wallet-has-forked
# github noted on that page is gone

set -e

cli=~/pivx/bin/pivx-cli
dt=`date`

function verifyStakeEnabled() {
  $cli getinfo | grep -e "staking status" | sed 's/.*://' | sed 's/,.*//' | tr -d [:blank:]
}

if [ `verifyStakeEnabled` != "\"StakingActive\"" ]; then
  mail -s "[pivx] stake heartbeat" "root" <<EOF
    Hourly heartbeat report $dt

    PIVX wallet is locked or otherwise not staking
EOF
fi
exit 0
