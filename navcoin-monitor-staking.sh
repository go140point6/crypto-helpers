#!/bin/bash
# saved as navcoin-monitor-staking.sh

# note this script requires jq
# sudo apt-get install jq

set -e

cli=~/navcoin/bin/navcoin-cli
dt=`date`

function getStakingInfo() {
  $cli getstakinginfo
}

enabled="$($cli getstakinginfo | jq -r '.enabled')"
staking="$($cli getstakinginfo | jq -r '.staking')"

if [[ $enabled != "true" || $staking != "true" ]]; then
  mail -s "[nav] stake heartbeat" "root" <<EOF

  Hourly heartbeat report $dt

  Navcoin wallet is locked or otherwise not staking

  `getStakingInfo`
EOF
fi
exit 0
