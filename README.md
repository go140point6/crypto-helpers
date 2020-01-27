# crypto-helpers
Scripts for various crypto projects (bash)

Any script that hits the same explorer (if applicable) should be scheduled with an offset to ensure they don't all hit the explorer at the same time.

Bitcoin Token : BTCT<br>
https://www.bitcointoken.pw/<br>
btct-check-fork.sh : check integrity of blockchain by comparing hashes. I check three times a day.<br>
btct-check-mn.sh : check that masternode(s) is still "ENABLED" and report last seen and paid times.  I check three times a day.<br>
btct-check-stake.sh : make sure staking is enabled and see what has been earned.  I check once daily.<br>
btct-monitor-staking.sh : heartbeat script to verify wallet unlocked and staking. I check hourly.</br>

NavCoin : NAV<br>
https://navcoin.org/en<br>
navcoin-check-fork.sh : check integrity of blockchain by comparing hashes. I check three times a day.<br>
navcoin-check-stake.sh : make sure staking is enabled and see what has been earned. I check once daily.<br>
navcoin-monitor-staking.sh : heartbeat script to verify wallet unlocked and staking. I check hourly.</br>

Neblio : NEBL<br>
https://nebl.io/<br>
neblio-check-fork.sh : check integrity of blockchain by comparing hashes. I check three times a day.<br>
neblio-check-stake.sh : make sure staking is enabled and see what has been earned. I check once daily.<br>
neblio-monitor-staking.sh : heartbeat script to verify wallet unlocked and staking. I check hourly.</br>

Private - Instant - Verified - Transaction : PIVX<br>
https://pivx.org/<br>
pivx-check-fork.sh : check integrity of blockchain by comparing hashes. I check three times a day.<br>
pivx-check-stake.sh : make sure staking is enabled and see what has been earned.  I check once daily.<br>
pivx-monitor-staking.sh : heartbeat script to verify wallet unlocked and staking. I check hourly.</br>
