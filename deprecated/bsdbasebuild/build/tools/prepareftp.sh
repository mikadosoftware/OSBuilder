#!/bin/sh
# simple copying to help me

#PWD is base of build system
CWD=$(pwd)
echo $CWD
TARGET=/home/ftp

cd $CWD/pkg_server
for i in $(ls)
do
 tar -cf $TARGET/$i.tar $i
done

cd $CWD
tar -cf $TARGET/support.tar support
tar -cf $TARGET/config_scripts.tar configure_server
cp -r install_scripts /home/ftp/

cd $CWD 
tar -cf $TARGET/portsbuilder.tar portsbuilder

cd $CWD
tar -cf $TARGET/deploy_scripts.tar deploy_scripts 
