# crypto-helpers
Scripts for various crypto projects (bash)

Note: The explorers are often behind the local blockchain.  Running a second (or third) time shows everything OK.

Note 2: Any script that hits an explorer should be staggered slightly to avoid rate limits of said API.

Note 3: NAV and PIVX scripts are in process of being rewritten similar to NEBL... NEBL should be usable now.

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
