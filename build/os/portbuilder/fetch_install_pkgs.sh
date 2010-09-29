#!/bin/sh

### This only works cos the tarballs were created in same tmp/pkgs dir as opened here.
### fix this by driving the tarball maker better

############################### USER VARIABLES ###############################
UNTAR=untar
VERSION=freebsd-7.1.0
FTPSVR=ftp.office.pirc.co.uk
PIRCTMP=/usr/local/PIRC/tmp/$UNTAR

### This is manually generated for now.
### need to parse Makefile in ports but read porter handbook chp 5 - bit complex
PKG_LIST="apache-2.2.11_4 apr-gdbm-db42-1.3.3.1.3.4_1 bash-4.0.10_2 \
git-1.6.2.2 mysql-client-5.1.33 python-2.5,2 py25-MySQLdb-1.2.2 \
py25-lxml-2.2 subversion-1.6.0_2 sudo-1.6.9.20"

PKG_LIST="apache-2.2.11_4"



PKG_LIST=""
PORTS_LIST="devel/subversion"

##############################################################################

echo "=> Starting install"
mkdir -p $PIRCTMP
cd $PIRCTMP

for PORT in $PORTS_LIST
do

#get the pkg name from port
cd /usr/ports/$PORT
PKG=`make package-name`
echo "==> discover $PORT is $PKG"


echo "==> Fetching $PKG"
echo setenv PACKAGESITE ftp://$FTPSVR/PACKAGES/$VERSION/
#setenv PACKAGESITE ftp://$FTPSVR/PACKAGES/$VERSION/
export PACKAGESITE=ftp://$FTPSVR/PACKAGES/$VERSION/

echo pkg_add -r $PKG.tbz
pkg_add -r $PKG.tbz

done



