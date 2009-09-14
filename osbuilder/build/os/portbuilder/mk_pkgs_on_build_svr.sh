#!/bin/sh

## pbrian@itmanagerscookbook.com

# every time we build from port, a pkg is created, and build info stored 
# in /var/db/pkgs
# distfiles in /usr/ports/disfiles
# options in /var/db/ports

#so we can build the pkgs using make package or a recursive version is pkg_create
#thus I specify the major pakages I want to build, and the pkg_create -R ensures that all the dependecy packages 
#are also built and stored in the major package directory

#http://www.onlamp.com/pub/a/bsd/2003/08/07/FreeBSD_Basics.html

#$1 should supply a variable called PKGLIST of form 
#PKGLIST="python25.1.2.3 "

. $1

#logging and constants
LOGDIR=`pwd`
WRKDIR=/usr/local/tmp
log=$LOGDIR/pkg_create.log
dd="date +%FT%H:%M:%S"

for i in $PKGLIST
do
 echo `$dd` starting $i >> $log
 mkdir -p l$WRKDIR/pkgs/$i
 cd $WRKDIR/pkgs/$i
 pkg_create -Rb $i
done

echo `$dd` Fin. >> $log


