#!/bin/bash
# saved as ltncg-sendto-main.sh

# sending secondary mining wallet balance to main wallet.
# Note: secondary wallet is unencrypted, obviously not recommended in most cases
# but as this is a secondary wallet doing CPU mining on a Pi, I don't really care.

set -e

cli=~/ltncg/bin/lightningcash-cli
# Change this address to your own unless you want to send me your coins... :)
main=MLyDkuXn7vioLoZkzaQA5exYoWbgySafvS

function getBalance() {
  $cli getbalance | awk '{print int($1)}'
}

function sendToMainWallet() {
  $cli sendtoaddress $main $balance
  local txoutput=$?
  echo $txoutput
}

# "root" corresponds to /etc/aliases (place email address there) and run newaliases
# or could also just put your email address here (no quotes)
function sendEmail() {
  mail -s "[ltncg] lightningcash payment to main" "root" <<EOF

  Sent $balance LTNC to $main with txid: $txid

EOF
}

balance=`getBalance`

if (( $balance > 100 )); then
  txid=`sendToMainWallet`
  `sendEmail`
  exit 0
fi

exit 0
