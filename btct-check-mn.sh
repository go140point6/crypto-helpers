#!/bin/bash
# saved as btct-check-mn.sh

# note this script requires jq
# sudo apt-get install jq

set -e

cli=~/btct/bin/btct-cli
dt=`date +%F\ %T`

# Certainly a better way to do this than run three times, will update when I figure it out
# Obviously replace "Baxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" with the address for your MN
mn01status="$($cli masternode list | jq '.[] | select (.addr == "Baxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx") | .status')"
mn01seen="$($cli masternode list | jq '.[] | select (.addr == "Baxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx") | .lastseen')"
mn01paid="$($cli masternode list | jq '.[] | select (.addr == "Baxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx") | .lastpaid')"

# "root" corresponds to /etc/aliases (place email address there) and run newaliases
# or could also just put your email address here (no quotes)
if [[ $mn01status == "\"ENABLED\"" ]]; then
  mail -s "[btct] MN01 heartbeat" "root" <<EOF

  Heartbeat report $dt

  BTCT MN01 appears to be OK:
    Status: $mn01status
    LastSeen: `date -d @$mn01seen`
    LastPaid: `date -d @$mn01paid`
EOF
else
  mail -s "[btct] MN01 heartbeat" "root" <<EOF

  Heartbeat report $dt

  BTCT MN01 appears to having issues, please check:
    Status: $mn01status
    LastSeen: `date -d @$mn01seen`
    LastPaid: `date -d @$mn01paid`
EOF
fi

mn02status="$($cli masternode list | jq '.[] | select (.addr == "Bbxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx") | .status')"
mn02seen="$($cli masternode list | jq '.[] | select (.addr == "Bbxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx") | .lastseen')"
mn02paid="$($cli masternode list | jq '.[] | select (.addr == "Bbxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx") | .lastpaid')"

# "root" corresponds to /etc/aliases (place email address there) and run newaliases
# or could also just put your email address here (no quotes)
if [[ $mn02status == "\"ENABLED\"" ]]; then
  mail -s "[btct] MN02 heartbeat" "root" <<EOF

  Heartbeat report $dt

  BTCT MN02 appears to be OK:
    Status: $mn02status
    LastSeen: `date -d @$mn02seen`
    LastPaid: `date -d @$mn02paid`
EOF
else
  mail -s "[btct] MN02 heartbeat" "root" <<EOF

  Heartbeat report $dt

  BTCT MN02 appears to having issues, please check:
    Status: $mn02status
    LastSeen: `date -d @$mn02seen`
    LastPaid: `date -d @$mn02paid`
EOF
fi

exit 0
