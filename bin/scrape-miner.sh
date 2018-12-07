#!/bin/bash

post(){
  echo "posting $@"
  curl -s -XPOST 'http://192.168.1.201:8086/write?db=home_assistant' --data-binary "$@"
}

get-summary(){
  echo -n '{"command":"summary"}' | fetch
}

get-stats(){
  echo -n '{"command":"stats"}' | fetch | perl -pe's!}\{!},\{!'
}

fetch(){
  nc antminer 4028
}

default() {
  rate=$( get-summary | jq '.SUMMARY[0]."GHS 5s"' )
  post "miner_rate,miner=antminer_1 value=$rate"

  stats=$( get-stats )

  temp1=$( echo $stats | jq '.STATS[1]."temp1"' )
  post "miner_temp,asc=1,miner=antminer_1 value=$temp1"

  temp2=$( echo $stats | jq '.STATS[1]."temp2"' )
  post "miner_temp,asc=2,miner=antminer_1 value=$temp2"

  temp3=$( echo $stats | jq '.STATS[1]."temp3"' )
  post "miner_temp,asc=3,miner=antminer_1 value=$temp3"

  fan1=$( echo $stats | jq '.STATS[1]."fan1"' )
  post "miner_fan,fan=1,miner=antminer_1 value=$fan1"

  fan3=$( echo $stats | jq '.STATS[1]."fan3"' )
  post "miner_fan,fan=3,miner=antminer_3 value=$fan3"
}

main(){
  if [ -z "$@" ] ; then
    default
  else
    $@
  fi
}

# run_or_die( $curl . "'miner_shares,miner=antminer_1 value=$shares'");
# run_or_die( $curl . "'miner_payout,miner=antminer_1 value=$payout'");
# run_or_die( $curl . "'miner_rate,miner=antminer_1 value=$rate'");   4.665k
# run_or_die( $curl . "'miner_t2s,miner=antminer_1 value=$t2s'");

main $@
