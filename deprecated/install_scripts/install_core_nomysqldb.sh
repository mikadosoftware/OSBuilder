#!/bin/sh

############################### USER VARIABLES ###############################
SERVERTYPE=core
VERSION=current
FTPSVR=ftp.office.pirc.co.uk
PIRCTMP=/usr/local/PIRC/tmp/$SERVERTYPE
##############################################################################

echo "=> Starting core install"
mkdir -p $PIRCTMP
cd $PIRCTMP

echo "==> Getting version $VERSION packages"
fetch ftp://$FTPSVR/PACKAGES/$VERSION/$SERVERTYPE.tgz

echo "==> Extracting"
tar -xvf $SERVERTYPE.tgz
cd $PIRCTMP/$SERVERTYPE

echo "==> Installing bash"
pkg_add bash-3.2.33.tbz
echo "==> Done"

echo "==> Installing python 2.5"
pkg_add python25-2.5.2_1.tbz
echo "==> Done"

echo "==> Installing screen"
pkg_add screen-4.0.3_1.tbz
echo "==> Done"

echo "==> Installing sudo"
pkg_add sudo-1.6.9.15_1.tbz
echo "==> Done"

hash

echo "==> Installing setuptools"
cd $PIRCTMP
fetch ftp://$FTPSVR/PACKAGES/MISC/ez_setup.py
python ez_setup.py -U setuptools

echo "==> Installing custom sudoers file (from svn)"
svn cat svn://svn/PIRC/projects/build_system/tags/$VERSION/support/sysadmin/sudoers > /usr/local/etc/sudoers
chmod 0440 /usr/local/etc/sudoers

echo "==> Cleaning up"
rm -r $PIRCTMP

echo "==> DONE"
