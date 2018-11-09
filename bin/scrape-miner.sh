#!/bin/bash

post(){
  echo "posting $@"
  curl -is -XPOST 'http://192.168.1.201:8086/write?db=home_assistant' --data-binary "$@"
}

fetch(){
  echo -n '{"command":"summary"}' | nc antminer 4028
}

rate=$( fetch | jq '.SUMMARY[0]."GHS 5s"' )
post "miner_rate,miner=antminer_1 value=$rate"

# run_or_die( $curl . "'miner_shares,miner=antminer_1 value=$shares'");
# run_or_die( $curl . "'miner_payout,miner=antminer_1 value=$payout'");
# run_or_die( $curl . "'miner_rate,miner=antminer_1 value=$rate'");   4.665k
# run_or_die( $curl . "'miner_t2s,miner=antminer_1 value=$t2s'");
