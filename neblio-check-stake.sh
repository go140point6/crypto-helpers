#!/bin/bash
# saved as neblio-check-stake.sh
# modification from original script by @givanse found on steemit.com:
# https://steemit.com/pivx/@givanse/how-to-check-if-your-pivx-wallet-has-forked
# github noted on that page is gone

set -e

cli=~/neblio/bin/nebliod
dt=`date`

function createFiles() {
if [ ! -f "balance.today" ]; then
  echo "$stakeToday" > "balance.today"
fi
if [ ! -f "balance.yesterday" ]; then
  echo "$stakeToday" > "balance.yesterday"
fi
}

function backupStakeInfo() {
  echo $stakeToday > balance.today
  echo $stakeToday > balance.yesterday
}

function verifyStakeActive() {
  $cli getstakinginfo
}

function getStakeBalance() {
  $cli getinfo | grep -w "balance" | sed "s/.*: \([0-9]\+.[0-9]\+\).*/\1/"
}

# first let's just get today's PIVX balance
stakeToday=`getStakeBalance`

# next le's create the files we need to be present (typically only on first run will this fire)
`createFiles`

# now let's compare yesterday's balance with today's to see if we earned anything from staking
stakeYesterday=$(<balance.yesterday)
# bash doens't support floating point arithmetic, so use external utility `bc`
stakeEarned=$(echo "$stakeToday - $stakeYesterday" | bc)

# let's get things ready for tomorrow's check
`backupStakeInfo`

# finally mail the report
mail -s "[nebl] daily stake report" "root" <<EOF
  Daily stake report for $dt

  `verifyStakeActive`

  $stakeEarned NEBL earned in the last 24H.
EOF
exit 0
