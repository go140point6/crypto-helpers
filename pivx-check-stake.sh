#!/bin/bash
# saved as pivx-check-stake.sh
#
# must have 'bc' installed (sudo apt-get install bc)

set -e

cli=~/pivx/bin/pivx-cli
dt=`date`

function createFiles() {
if test ! -f ~/pivx/bin/balance.today; then
  echo $stakeToday > ~/pivx/bin/balance.today
fi
if test ! -f ~/pivx/bin/balance.yesterday; then
  echo $stakeToday > ~/pivx/bin/balance.yesterday
fi
}

function backupStakeInfo() {
  echo $stakeToday > ~/pivx/bin/balance.today
  echo $stakeToday > ~/pivx/bin/balance.yesterday
}

function verifyStakeActive() {
  $cli getstakingstatus
}

function getStakeBalance() {
  $cli getinfo | grep -w "balance" | sed "s/.*: \([0-9]\+.[0-9]\+\).*/\1/"
}

# first let's just get today's PIVX balance
stakeToday=`getStakeBalance`

# next le's create the files we need to be present (typically only on first run will this fire)
`createFiles`

# now let's compare yesterday's balance with today's to see if we earned anything from staking
stakeYesterday=$(<~/pivx/bin/balance.yesterday)

# bash doens't support floating point arithmetic, so use external utility `bc`
stakeEarned=$(echo "$stakeToday - $stakeYesterday" | bc)
# let's get things ready for tomorrow's check
`backupStakeInfo`

# finally mail the report
mail -s "[pivx] daily stake report" "root" <<EOF
  Daily stake report for $dt

  `verifyStakeActive`

  $stakeEarned PIVX earned in the last 24H.
EOF
exit 0
