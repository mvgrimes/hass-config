#!/bin/bash

url="http://localhost:8123"
topic="hass/mqtt-say/message"
config_dir="/config"

log() { echo "$@" >&2; }

usage() {
  echo "usage: mqtt-tts -d <config dir> -p <http API password> -t <mqtt topic> <message>"
  echo $@
  echo "   -t  topic to publish to (default: $topic)"
  echo "   -p  <http API password>"
  echo "   -d  config dir (default: $config_dir)"
  echo "   -h  help"
  exit 1
}

while getopts ":p:t:h:d:" opt; do
    case $opt in
        t)  topic="$OPTARG"                               ;;
        p)  http_api_password="$OPTARG"                   ;;
        d)  config_dir="$OPTARG"                   ;;
        h)  usage "Invalid option: -$OPTARG"              ;;
        :)  usage "Option -$OPTARG requires an argument." ;;
    esac
done

# Decrements the argument pointer so it points to the next argument
shift $(($OPTIND - 1))

if [ ! -z "$@" ] ; then
    message="$@"
else
    message=$(</dev/stdin)
fi

if [ -z "$http_api_password" ] ; then
    http_api_password=$( perl -ne's/^http_api_password:\s*// && print' < $config_dir/secrets.yaml )
fi

# logfile="$config_dir/nik.log"
# [ -t 0 ] || exec >> "$logfile" 2>&1

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

[ -z "$message" ] && usage "No message"

tts_url=$( get-tts-file "$message" )
mqtt-publish "$topic" "$tts_url"
