#!/bin/bash
# saved as pivx-monitor-staking.sh
# run on the hour

# note this script requires jq
# sudo apt-get install jq

set -e

cli=~/pivx/bin/pivx-cli
dt=`date +%F\ %T`

function getStakingInfo() {
  $cli getinfo
}

enabled="$($cli getinfo | jq -r '.["staking status"]')"

echo $dt $enabled >> ~/pivx/bin/results.log

# "root" corresponds to /etc/aliases (place email address there) and run newaliases
# or could also just put your email address here (no quotes)
if [[ $enabled == "Staking Active" ]]; then
  # do nothing, staking appears active
  exit
else
  # send email, stkaing appears not to be active
  mail -s "[pivx] stake heartbeat" "root" <<EOF

  Hourly heartbeat report $dt

  PIVX wallet is not staking for some reason (wallet locked?)

  `getStakingInfo`
EOF
exit
fi
