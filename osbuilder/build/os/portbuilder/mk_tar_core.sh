#!/bin/sh

#####
# pbrian
# we create a series of top level package folders
# where there are bsd packages for each app that is reqd to build 
# the top level (ie apache22/ holds httpd1.23 and perl5.123 and ...)

# For many packages (mysql) this is sufficient, however for a base or
# core install, there are a lot of apps (sudo, bash etc) and it seems
# easiest to just lump them all in one big go

PKGSROOT=/tmp/pkgs
SERVERTYPE=www
VERSION=2.1.0
COREFOLDER=$PKGSROOT/$VERSION/$SERVERTYPE
mkdir -p $COREFOLDER
PUTINCORE="bash-3.2.33 python25-2.5.2_1 py25-MySQLdb-1.2.2 screen-4.0.3_1 \
subversion-1.4.6_1 sudo-1.6.9.15_1 apr-db42-1.2.8_3"

PUTINCORE="mysql-server-5.1.24"
PUTINCORE="apache-2.2.8"


for i in $PUTINCORE
do
 echo starting $i
 cp -v $PKGSROOT/$i/* $COREFOLDER/
done

cd $PKGSROOT/$VERSION
tar -czf $SERVERTYPE.tgz $SERVERTYPE

