#!/bin/sh

HOST=$1
IP=$2

echo 'Killing jail $HOST'

sh stopjail.sh $HOST.office.pirc.co.uk $IP
echo sleeping ...
sleep 5


umount /usr/jail/$HOST/dev 
umount /usr/jail/$HOST/proc

chflags -R 0 /usr/jail/$HOST

rm -rf /usr/jail/$HOST

echo 'you probably need to reboot and rm /usr/jail/$HOST'

