#!/bin/sh

############################### USER VARIABLES ###############################
SERVERTYPE=phpextns
VERSION=current
FTPSVR=ftp.office.pirc.co.uk
PIRCTMP=/usr/local/PIRC/tmp/$SERVERTYPE
##############################################################################

echo "=> Starting $SERVERTYPE install"
mkdir -p $PIRCTMP
cd $PIRCTMP

echo "==> Getting version $VERSION packages"
fetch ftp://$FTPSVR/PACKAGES/$VERSION/$SERVERTYPE.tgz

echo "==> Extracting php"
tar -xvf $SERVERTYPE.tgz
cd $PIRCTMP/$SERVERTYPE



echo "==> Installing php"
pkg_add php5-extensions-1.1.tbz
echo "==> Done"

hash

echo "==> Cleaning up"
rm -r $PIRCTMP

echo "==> DONE"
