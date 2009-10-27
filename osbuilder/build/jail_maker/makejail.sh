#!/bin/sh

### useage $ sh makejail.sh <hostname> <ip>

### pbrian
##
#  There are 3 stages of jails in FreeBSD.  - canonical.  This
#  rebuilds from source all the binaries for userland, it is correct,
#  but takes a v long time to build just one - Fast build, slow
#  ugrade.  This does not build from source but uses installworld to
#  copy the host binaries to the jail location.  It is faster to build
#  a jail (which for dev purposes is good) but it is just as hard to
#  upgrade the world
#
#  - "services" jails, now part of handbook, uses nullfs to mount
#                 (most) of the binaries from the host in the
#                 locations for the jail.  Complicated but once
#                 working only needs upgrade in one location.
#

###  For now I am concentrating on "fast build, slow upgrade".

##### canonical 

WORKINGDIR=`pwd`

HOSTNAME=$1
IP=$2

D=/usr/jail/$HOSTNAME
cd /usr/src
mkdir -p $D
make installworld DESTDIR=$D
make distribution DESTDIR=$D

#mount -t devfs devfs $D/dev

cd $WORKINGDIR
python prepjail.py $HOSTNAME $IP
python virginjailconfig.py $HOSTNAME $IP
#/etc/rc.d/netif restart  #restart the networking for this jail
/etc/rc.d/jail start $HOSTNAME

echo "You now still need to config the root passwd to be able to log on"
echo "And I see some strange effects on this without a reboot"


