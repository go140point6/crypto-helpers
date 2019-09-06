#!/bin/bash
# saved as dogp-monitor-staking.sh
# run on the hour

# note this script requires jq
# sudo apt-get install jq

set -e

cli=~/dogp/bin/dogecoinprivate-cli
dt=`date +%F\ %T`

function getStakingInfo() {
  $cli getstakingstatus
}

enabled="$($cli getinfo | jq -r '.["staking status"]')"

echo $dt $enabled >> ~/dogp/bin/results.log

# "root" corresponds to /etc/aliases (place email address there) and run newaliases
# or could also just put your email address here (no quotes)
if [[ $enabled == "Staking Active" ]]; then
  # do nothing, staking appears active
  exit
else
  # send email, stkaing appears not to be active
  mail -s "[dogp] stake heartbeat" "root" <<EOF

  Hourly heartbeat report $dt

  DOGP wallet is not staking for some reason (wallet locked?)

  `getStakingInfo`
EOF
exit
fi
