#!/bin/sh

STATE=`nmcli networking connectivity`

if [ $STATE = 'full' ]
then
    #/usr/local/bin/msmtp-runqueue.sh
    mbsync -qq work
    exit 0
fi
echo "No internet connection."
exit 0

