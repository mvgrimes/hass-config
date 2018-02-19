#!/bin/bash

miner="antminer"
user="root"

usage() {
  echo "usage: restart-miner -m <miner IP or host> -u <user>"
  echo $@
  echo "   -u  miner ssh username"
  echo "   -m  miner address"
  echo "   -h  help"
  exit 1
}

while getopts ":p:u:m:h" opt; do
    case $opt in
        p)  usage "Use ssh keys"                          ;;
        u)  user="$OPTARG"                                ;;
        m)  miner="$OPTARG"                               ;;
        \?) usage "Invalid option: -$OPTARG"              ;;
        :)  usage "Option -$OPTARG requires an argument." ;;
    esac
done

# Decrements the argument pointer so it points to the next argument
shift $(($OPTIND - 1))

ssh "$user@$miner" '/sbin/reboot'
