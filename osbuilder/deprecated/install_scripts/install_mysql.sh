#!/bin/sh

############################### USER VARIABLES ###############################
SERVERTYPE=mysql-server
VERSION=current
FTPSVR=ftp.office.pirc.co.uk
PIRCTMP=/usr/local/PIRC/tmp
##############################################################################

mkdir -p $PIRCTMP
cd $PIRCTMP

echo "==> Fetching MySQL"
fetch ftp://$FTPSVR/PACKAGES/$VERSION/$SERVERTYPE.tgz
tar -xvf $SERVERTYPE.tgz
cd $SERVERTYPE

echo "==> Installing MySQL 5.1.26"
pkg_add mysql-server-5.1.26.tbz

hash

echo "==> DONE"

