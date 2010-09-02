#!/bin/sh

############################### USER VARIABLES ###############################
SERVERTYPE=svn_client
VERSION=current
FTPSVR=ftp.office.pirc.co.uk
PIRCTMP=/usr/local/PIRC/tmp/$SERVERTYPE
##############################################################################

echo "=> Starting $SERVERTYPE install"
mkdir -p $PIRCTMP
cd $PIRCTMP

echo "==> Getting version $VERSION packages"
fetch ftp://$FTPSVR/PACKAGES/$VERSION/$SERVERTYPE.tgz

echo "==> Extracting"
tar -xvf $SERVERTYPE.tgz
cd $PIRCTMP/$SERVERTYPE

echo "==> installing subversion"
pkg_add subversion-1.5.0_4.tbz
echo "==> done"
hash

echo "==> Cleaning up"
rm -r $PIRCTMP

echo "==> DONE"
