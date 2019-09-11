#!/bin/bash
# saved as navcoin-monitor-staking.sh

# note this script requires jq
# sudo apt-get install jq

set -e

cli=~/navcoin/bin/navcoin-cli
dt=`date +%F\ %T`

function getStakingInfo() {
  $cli getstakinginfo
}

enabled="$($cli getstakinginfo | jq -r '.enabled')"
staking="$($cli getstakinginfo | jq -r '.staking')"
errors="$($cli getstakinginfo | jq -r '.errors')"

# check if $errors is null and replace with text if so
if [ -z "$errors" ]; then
  errors="none"
fi

echo $dt "enabled:$enabled" "staking:$staking" "errors:$errors" >> ~/navcoin/bin/results.log

# "root" corresponds to /etc/aliases (place email address there) and run newaliases
# or could also just put your email address here (no quotes)
if [[ $staking == "true" || $errors="Warning: We don't appear to have mature coins." ]]; then
  # do nothing, staking is OK or we just got a deposit
  exit
else
  mail -s "[nav] stake heartbeat" "root" <<EOF

  Hourly heartbeat report $dt

  Navcoin wallet is locked or otherwise not staking for some reason

  `getStakingInfo`
EOF
fi
exit 0
