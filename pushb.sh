#!/bin/bash

#pushb config file location
export PUSHRC="$HOME/.pushb"
[ -f $PUSHRC ] && source $PUSHRC

usage() {
  echo "Usage: $0"
  echo " -c : (re)configure"
  echo " -l : list devices & their IDs then exit"
  echo " -n <device_id> : push to device_id (ie \"u1qSJddxeKwOGuGW\")"
  echo " -d <device_id> : set device_id as the default push device then exit"
  echo " -f <format> : use $format (note|link|address|list|file)"
  echo " -t <title> : use $title"
  exit 1
}

function listDevs(){
  curl -s -u "$APIKEY:" https://api.pushbullet.com/api/devices |python -c '
import sys
import json
k = json.loads(sys.stdin.readlines()[0])
for i in k["devices"]:
  did = i["iden"]
  name = i["extras"]["manufacturer"] + " " + i["extras"]["model"]
  print("id: " + did + " description: " + name)
'
}

function setConfig(){
  echo -n "API Key: "
  read APIKEY
  echo "APIKEY=$APIKEY" > $PUSHRC
  echo "Cool! Let's find some devices to push to now"
  listDevs
  echo -n "ID to use as default: "
  read PRIDEV
  echo "PRIDEV=$PRIDEV" >> $PUSHRC
  echo "All Set! try it -> echo test |pushb"
}

while getopts ":cld:n:f:t:" o; do
  case "${o}" in
    c)
      [ -f $PUSHRC ] && rm $PUSHRC
      setConfig
      exit
      ;;
    n)
      DEVID=$OPTARG
      ;;
    l)
      listDevs
      exit
      ;;
    f)
      FMT=$OPTARG
      ;;
    t)
      TITLE=$OPTARG
      ;;
    d)
      if [ `uname` == "Darwin" ]
      then
        sed -i '' -e "s/PRIDEV=.*/PRIDEV=$OPTARG/" $PUSHRC
      else
        sed -i -e "s/PRIDEV=.*/PRIDEV=$OPTARG/" $PUSHRC
      fi
      exit
      ;;
    *)
      usage
      ;;
  esac
done

source $PUSHRC 2> /dev/null
if [ $? -gt 0 ]
then
  echo "Error, can't find config file"
  echo "Maybe you need to set up pushb first, try:"
  echo "$0 -c"
  exit 1
fi

[ -z "$FMT" ] && FMT="note"
[ -z "$TITLE" ] && TITLE="pushb@`hostname`"
[ ! -z "$DEVID" ] && PRIDEV=$DEVID

curl https://api.pushbullet.com/api/pushes \
  -s \
  -u "$APIKEY:" \
  -d device_iden=$PRIDEV \
  -d type=$FMT \
  -d title="$TITLE" \
  -d body="`cat /dev/stdin`" \
  -X POST > /dev/null

