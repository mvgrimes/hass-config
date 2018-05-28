#!/bin/bash

url="http://localhost:8123"
topic_ring="hass/mqtt-say/ring"
topic_say="hass/mqtt-say/message"
config_dir="/config"

log() { echo "$@" >&2; }

usage() {
  echo "usage: notify-if-known -p <phone number> -n <name> -d <config dir> -H <http API password> -t <mqtt topic>"
  echo $@
  echo "   -p  phone number to lookup"
  echo "   -n  name to use in notification"
  echo "   -t  topic to publish to (default: $topic)"
  echo "   -H  <http API password>"
  echo "   -d  config dir (default: $config_dir)"
  echo "   -h  help"
  exit 1
}

while getopts ":p:n:t:H:d:" opt; do
    case $opt in
        p)  phone="$OPTARG"                               ;;
        n)  name="$OPTARG"                                ;;
        t)  topic="$OPTARG"                               ;;
        H)  http_api_password="$OPTARG"                   ;;
        d)  config_dir="$OPTARG"                   ;;
        \?) usage "Invalid option: -$OPTARG"              ;;
        :)  usage "Option -$OPTARG requires an argument." ;;
    esac
done

# Decrements the argument pointer so it points to the next argument
shift $(($OPTIND - 1))

database="$config_dir/phones.sqlite"
pysqlite="$config_dir/bin/check-is-known.py"
logfile="$config_dir/nik.log"

[ -t 0 ] || exec >> "$logfile" 2>&1

# TODO: ensure payload is properly escaped
mqtt-publish() {
    local topic=$1
    local payload=$2

    log "publish: $payload"
    curl -s -X POST \
        -H "x-ha-access: $http_api_password" \
        -H "Content-TYpe: application/json" \
        -d "{\"topic\": \"$topic\", \"payload\": \"$payload\"}" \
        "$url/api/services/mqtt/publish"

}

get-tts-file() {
    local text="$1"

    log "get-tts-file: $text"
    curl -s -X POST \
        -H "x-ha-access: $http_api_password" \
        -H "Content-TYpe: application/json" \
        -d "{\"message\": \"$text\", \"platform\": \"google\"}" \
        "$url/api/tts_get_url" | perl -MJSON::PP=decode_json -E'print decode_json(<>)->{url}'
}

is-friend() {
    # Cleanup phone number
    phone=$( echo "$1" | perl -pE's{\D}{}g; s{^1}{}g' )
    [ -n "$phone" ] || return 1  # false

    log "checking $phone"
    res=$( $pysqlite "$database" "$phone" )
    err=$?

    # log "is-friend -> $res"
    # log "is-friend => $err"

    if [ -n "$res" ] ; then
        # [ -z "$name" ] && name="$res"
        name="$res"
        true
    else
        false
    fi
}


[ -z "$phone" ] && usage "No phone specified"

if is-friend "$phone" ; then
    [ -n "$name" ] || name="$phone"
    # mqtt-publish "$topic_ring" "short-ring"

    tts_url=$( get-tts-file "Incoming call from $name" )
    mqtt-publish "$topic_say" "$tts_url"
else
    log "We don't know you! $phone"
fi
