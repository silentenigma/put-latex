#!/bin/sh

if [ $# -lt 2 ]; then
  echo "Usage:"
  echo "       rsh... [ -q | --quiet ] hosts_file remote_command"
  exit 1
fi

HOSTS=$1
shift

if [ "$1" = "-q" -o "$1" = "--quiet" ]; then
  quiet=true
  shift
fi

sed -e 's/#.*//' -e '/^[ \t]*$/d' $HOSTS |
while read H
do
if [ ! $quiet ]; then
  ( ssh $H "$*" && echo "($*) on host $H is OK" || echo "($*) failed on host $H!" )&
else
  #( ssh $H $* && echo "OK on host $H" || echo "failed on host $H!" )&
  ( ssh $H "$*" && echo "OK on host $H" || echo "Failure on host $H!")&
fi
done
#wait
#echo "rsh... terminated"