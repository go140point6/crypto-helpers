#!/bin/bash
# saved as neblio-monitor-staking.sh
# run on the hour

# note this script requires jq
# sudo apt-get install jq

set -e

cli=~/neblio/bin/nebliod
dt=`date`

function getStakingInfo() {
  $cli getstakinginfo
}

enabled="$($cli getstakinginfo | jq -r '.enabled')"
mature="$($cli getstakinginfo | jq -r '.["staking-criteria"]."mature-coins"')"
unlocked="$($cli getstakinginfo | jq -r '.["staking-criteria"]."wallet-unlocked"')"
online="$($cli getstakinginfo | jq -r '.["staking-criteria"].online')"
sync="$($cli getstakinginfo | jq -r '.["staking-criteria"].synced')"

# "root" corresponds to /etc/aliases (place email address there) and run newaliases
# or could also just put your email address here (no quotes)
if [ $enabled != "true" ]; then
  mail -s "[nebl] stake heartbeat" "root" <<EOF

  Hourly heartbeat report $dt

  Neblio wallet is not enabled for some reason

  `getStakingInfo`
EOF
exit
fi

if [[ $unlocked != "true" || $online != "true" || $sync != "true" ]]; then
  mail -s "[nebl] stake heartbeat" "root" <<EOF
    Hourly heartbeat report $dt

    Neblio wallet is not staking for some reason

    `getStakingInfo`
EOF
else
  if [ $mature != true ]; then
    # do nothing, probably just got a stake in the last 24 hours
    exit
  fi
fi
exit
