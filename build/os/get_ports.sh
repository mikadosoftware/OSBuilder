#### get ports, then rebuild world and kernel on a clean installed machine
FOLDER=`pwd`
LOGFOLDER=$FOLDER/log
CONFIGFOLDER=$FOLDER/config

log=$LOGFOLDER/build.log
dd="date +%FT%H:%M:%S"

echo `$dd` start_grab_ports >> $log
pkg_add -r cvsup-without-gui
rehash

echo `$dd` start cvsup >> $log
                                                                                cvsup $CONFIGFOLDER/ports-supfile
cvsup $CONFIGFOLDER/src-supfile
