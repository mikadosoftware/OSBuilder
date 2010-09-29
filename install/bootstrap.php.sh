#!/usr/bin/env sh

PACKAGESITE=ftp://ftp/PACKAGES/All/
export PACKAGESITE

packages="\
bash-4.0.17.tbz curl-7.19.4.tbz git-1.6.2.5.tbz python25-2.5.4_1.tbz \
screen-4.0.3_6.tbz sudo-1.6.9.20.tbz subversion-1.6.1.tbz \
rsync-3.0.5.tbz php5-5.2.9.tbz php5-extensions-1.3.tbz"

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
git checkout 0.9a3
easy_install fabric/
rm -r fabric

echo "==> Getting sudoers"
svn export svn://svn/PIRC/projects/build_system/trunk/install/sudoers
cat sudoers > /usr/local/etc/sudoers
rm sudoers

unset PACKAGESITE
echo "==> Done"
