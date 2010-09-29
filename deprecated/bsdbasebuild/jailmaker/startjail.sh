#!/bin/sh

HOST=$1
IP=$2
echo starting jail $HOST on IP $IP


mount -t devfs devfs /usr/jail/$HOST/dev 
mount -t procfs proc /usr/jail/$HOST/proc
mkdir /usr/jail/$HOST/usr/ports
mount_nullfs /usr/ports /usr/jail/$HOST/usr/ports

rm /usr/jail/$HOST/var/spool/mqueue/*
rm /usr/jail/$HOST/var/spool/clientmqueue/*
rm /usr/jail/$HOST/var/mail/root
rm -R /usr/jail/$HOST/tmp/*

/usr/local/sbin/jstart /usr/jail/$HOST $HOST $IP /bin/sh /etc/rc


