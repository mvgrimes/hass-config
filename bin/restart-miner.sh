#!/bin/bash

miner="antminer"
user="root"
password="admin"

usage() {
  echo "usage: restart-miner -m <miner IP or host> -u <user> -p <password>"
  echo $@
  echo "   -p  miner ssh password"
  echo "   -u  miner ssh username"
  echo "   -m  miner address"
  echo "   -h  help"
  exit 1
}

while getopts ":p:u:m:h" opt; do
    case $opt in
        p)  password="$OPTARG"                               ;;
        u)  user="$OPTARG"                                ;;
        m)  miner="$OPTARG"                               ;;
        \?) usage "Invalid option: -$OPTARG"              ;;
        :)  usage "Option -$OPTARG requires an argument." ;;
    esac
done

# Decrements the argument pointer so it points to the next argument
shift $(($OPTIND - 1))

ssh "$user@$password:$miner" 'restart'
