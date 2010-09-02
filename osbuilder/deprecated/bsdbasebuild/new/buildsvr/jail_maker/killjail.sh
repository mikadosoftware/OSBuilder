#!/bin/sh


HOSTNAME=$1
IP=$2
JID=.jexec_extract.py $HOSTNAME

echo $JID
exit

D=/usr/jail/$HOSTNAME

echo "jexec $JID /etc/rc.shutdown"

exit

umount /usr/jail/$HOST/dev
umount /usr/jail/$HOST/proc

chflags -R 0 /usr/jail/$HOST

rm -rf /usr/jail/$HOST

