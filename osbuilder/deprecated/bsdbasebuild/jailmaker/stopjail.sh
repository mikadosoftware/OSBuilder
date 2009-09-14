#!/bin/sh

HOST=$1
IP=$2
echo stopping jail $HOST on IP $IP

/usr/local/sbin/jkill $HOST.office.pirc.co.uk
umount /usr/jail/$HOST/proc
umount /usr/jail/$HOST/dev
umount /usr/jail/$HOST/usr/ports
echo ' ... ... ...'
echo '   ... ...  '
