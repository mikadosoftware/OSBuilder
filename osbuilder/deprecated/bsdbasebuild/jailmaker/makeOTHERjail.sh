#!/bin/sh
###
# THis is to make a jail *after* the first jail
# with buildworld has been done (in fact I think it
# can run after host buildworld...?)
#
# basically, after we have got the binaries built
# all we need do is installworld...
#
###

REF=$1
HOSTNAME=$2
IP=$3

D=/usr/jail/$HOSTNAME
cd /usr/src
mkdir -p $D
make installworld DESTDIR=$D
make distribution DESTDIR=$D
#mount -t devfs devfs $D/dev

cd /usr/home/pbrian/build/trunk/bsdbasebuild/jailmaker
python virginjailconfig.py $REF $HOSTNAME $IP

