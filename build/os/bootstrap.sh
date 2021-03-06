#!/usr/bin/env sh

PACKAGESITE=ftp://ftp/PACKAGES/freebsd-7.1.0/
export PACKAGESITE

packages="bash-4.0.17.tbz curl-7.19.4.tbz git-1.6.2.5.tbz python25-2.5.4_1.tbz screen-4.0.3_6.tbz sudo-1.6.9.20.tbz subversion-1.6.1.tbz mysql-client-5.1.34.tbz"

echo "==> bootstrapping server"                                                                      
for i in $packages; do
    echo "    ==> Installing $i"
    pkg_add -r $i
done

echo "==> Installing python libraries"
echo "    ==> Installing easy_install"
curl http://peak.telecommunity.com/dist/ez_setup.py | python

echo "    ==> Installing fabric deployment tools"
## easy_install fabric
## THIS IS TEMPORARY UNTIL 1.0 IS RELEASED
git clone git://github.com/bitprophet/fabric.git
easy_install fabric/
rm -r fabric

echo "==> Fixing sudoers"

echo "==> Fixing ssh config"

unset PACKAGESITE
echo "==> Done"
