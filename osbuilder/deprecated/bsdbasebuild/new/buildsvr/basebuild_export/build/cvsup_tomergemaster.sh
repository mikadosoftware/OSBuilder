#!/bin/sh

#maintining ports - portupgrade -arR will recursively keep ports uptodate, if cvsup ports regularly.

#### get ports, then rebuild world and kernel on a clean installed machine
FOLDER=`pwd`
LOGFOLDER=$FOLDER/log
CONFIGFOLDER=$FOLDER/config

log=$LOGFOLDER/build.log
dd="date +%FT%H:%M:%S"

echo `$dd` start_cvsup2mergemaster >> $log
pkg_add -r cvsup-without-gui
rehash

echo `$dd` start cvsup >> $log
#cvsup $CONFIGFOLDER/ports-supfile
cvsup $CONFIGFOLDER/src-supfile

echo `$dd` start makeworld >> $log
echo NO_PROFILE=true >> /etc/make.conf
cd /usr/src
make -j6 buildworld

echo `$dd` start kernelbuild >> $log
cd /usr/src
make buildkernel KERNCONF=GENERIC
make installkernel KERNCONF=GENERIC


echo `$dd` start installworld >> $log
cd /usr/src
echo make installworld
make installworld
echo now run mergemaster
#run so that it automatically installs new config files, and puts any diffs into /var/tmp/temproot.xxx
mergemaster -ia
echo `$dd` rebooting >> $log
reboot


