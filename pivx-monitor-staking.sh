#!/bin/bash
# saved as pivx-monitor-staking.sh
# run on the hour

# note this script requires jq
# sudo apt-get install jq

set -e

cli=~/pivx/bin/pivx-cli
dt=`date +%F\ %T`

function getStakingStatus() {
  $cli getstakingstatus
}

validtime="$($cli getstakingstatus | jq -r '.validtime')"
haveconnections="$($cli getstakingstatus | jq -r '.haveconnections')"
walletunlocked="$($cli getstakingstatus | jq -r '.walletunlocked')"
mintablecoins="$($cli getstakingstatus | jq -r '.mintablecoins')"
enoughcoins="$($cli getstakingstatus | jq -r '.enoughcoins')"
mnsync="$($cli getstakingstatus | jq -r '.mnsync')"
staking="$($cli getstakingstatus | jq -r '.["staking status"]')"

echo $dt "validtime:$validtime" "haveconnections:$haveconnections" "walletunlocked:$walletunlocked" "mintablecoins:$mintablecoins" "mnsync:$mnsync" "staking:$staking" >> ~/pivx/bin/results.log

# "root" corresponds to /etc/aliases (place email address there) and run newaliases
# or could also just put your email address here (no quotes)
if [[ $staking == "true" ]]; then
  # do nothing, staking appears active
  exit
else
  # send email, staaking appears not to be active
  mail -s "[pivx] stake heartbeat" "root" <<EOF

  Hourly heartbeat report $dt

  PIVX wallet is not staking, see below for reason:

  `getStakingStatus`
EOF
exit
fi
