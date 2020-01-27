#!/bin/bash
# saved as btct-check-stake.sh
#
# must have 'bc' installed (sudo apt-get install bc)
set -e

cli=~/btct/bin/btct-cli
dt=`date`

function createFiles() {
if test ! -f ~/btct/bin/balance.today; then
  echo $stakeToday > ~/btct/bin/balance.today
fi
if test ! -f ~/btct/bin/balance.yesterday; then
  echo $stakeToday > ~/btct/bin/balance.yesterday
fi
}

function backupStakeInfo() {
  echo $stakeToday > ~/btct/bin/balance.today
  echo $stakeToday > ~/btct/bin/balance.yesterday
}

function verifyStakeActive() {
  $cli getstakingstatus
}

function getStakeBalance() {
  $cli getwalletinfo | grep -w "balance" | sed "s/.*: \([0-9]\+.[0-9]\+\).*/\1/"
}

# first let's just get today's BTCT balance
stakeToday=`getStakeBalance`

# next le's create the files we need to be present (typically only on first run will this fire)
`createFiles`

# now let's compare yesterday's balance with today's to see if we earned anything from staking
stakeYesterday=$(<~/btct/bin/balance.yesterday)

# bash doens't support floating point arithmetic, so use external utility `bc`
stakeEarned=$(echo "$stakeToday - $stakeYesterday" | bc)
# let's get things ready for tomorrow's check
`backupStakeInfo`

# finally mail the report
# "root" corresponds to /etc/aliases (place email address there) and run newaliases
# or could also just put your email address here (no quotes)
mail -s "[btct] daily stake report" "root" <<EOF
  Daily stake report for $dt

  `verifyStakeActive`

  $stakeEarned BTCT accumulated in the last 24H.
EOF
exit 0
