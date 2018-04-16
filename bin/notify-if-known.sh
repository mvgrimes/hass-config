#!/bin/bash

url="http://localhost:8123"
topic_ring="hass/mqtt-say/ring"
topic_say="hass/mqtt-say/message"
# database="/Users/mgrimes/src/hass/config/phones.sqlite"
# pysqlite="/Users/mgrimes/src/hass/config/bin/check-is-known.py"
# logfile="/Users/mgrimes/src/hass/config/nik.log"
database="/srv/app/hass/config/phones.sqlite"
pysqlite="/srv/app/hass/config/bin/check-is-known.py"
logfile="/srv/app/hass/config/nik.log"

[ -t 0 ] && exec >> "$logfile" 2>&1

usage() {
  echo "usage: notify-if-known -p <phone number> -n <name> -H <http API password> -t <mqtt topic>"
  echo $@
  echo "   -p  phone number to lookup"
  echo "   -n  name to use in notification"
  echo "   -t  topic to publish to (default: $topic)"
  echo "   -H  <http API password>"
  echo "   -h  help"
  exit 1
}

while getopts ":p:n:t:H:" opt; do
    case $opt in
        p)  phone="$OPTARG"                               ;;
        n)  name="$OPTARG"                                ;;
        t)  topic="$OPTARG"                               ;;
        H)  http_api_password="$OPTARG"                   ;;
        \?) usage "Invalid option: -$OPTARG"              ;;
        :)  usage "Option -$OPTARG requires an argument." ;;
    esac
done

# Decrements the argument pointer so it points to the next argument
shift $(($OPTIND - 1))

# TODO: ensure payload is properly escaped
mqtt-publish() {
    local topic=$1
    local payload=$2

    echo "publish: $payload"
    curl -s -X POST \
        -H "x-ha-access: $http_api_password" \
        -H "Content-TYpe: application/json" \
        -d "{\"topic\": \"$topic\", \"payload\": \"$payload\"}" \
        "$url/api/services/mqtt/publish"
}

is-friend() {
    # Cleanup phone number
    phone=$( echo "$1" | perl -pE's{\D}{}g; s{^1}{}g' )
    [ -n "$phone" ] || return 1  # false

    echo "checking $phone"
    res=$( $pysqlite "$database" "$phone" )
    err=$?

    # echo "is-friend -> $res"
    # echo "is-friend => $err"

    if [ -n "$res" ] ; then
        [ -z "$name" ] && name="$res"
        true
    else
        false
    fi
}


[ -z "$phone" ] && usage "No phone specified"

if is-friend "$phone" ; then
    [ -n "$name" ] || name="$phone"
    mqtt-publish "$topic_ring" "short-ring"
    # mqtt-publish "$topic_say" "Incoming call from $name"
else
    echo "We don't know you!"
fi
