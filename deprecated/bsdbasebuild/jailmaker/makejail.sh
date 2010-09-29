#!/bin/sh
HOSTNAME=$1
D=/usr/jail/$HOSTNAME
cd /usr/src
mkdir -p $D
make -j6 world DESTDIR=$D
make distribution DESTDIR=$D

#this is done later
#mount_devfs devfs $D/dev

#do not do these - we need the src files for make installworld
#cd /usr/src
#make clean
