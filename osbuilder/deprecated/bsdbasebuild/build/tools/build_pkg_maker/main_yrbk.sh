# pbrian sept 5
# brief: installtion script for generic FREEBSD server

###
# 1. create a minimal freebsd server, using sysinstall.
#    add the correct hostnames etc, make it ssh compatible, also add a user "installer" with wheel group
# 2. then login (console ok) and fetch main_<servertype>.sh 
# 3. run that as root on that machine.
# future - install.cfg from floppy and eventually from PXE

#######
# Expects an anonymous ftp server (pureftp is in KB) that holds cvsupfile.
# put this file in same location and fetch from minimal server then run this. 
# fetch ftp://192.168.1.10/install1.sh
#######

#CONSTANTS
FTPSVR=pbrian.office.pirc.co.uk
PIRC_root=/usr/local/PIRC
PIRC_log_dir=/usr/local/tmp/log
PIRC_this_hostname=`hostname`
SRC_root=$PIRC_root/tmp/NEW_BASE_SVR


### Export for rest of scripts to use
export PIRC_root
export PIRC_log_dir
export PIRC_this_hostname
export SRC_root

###make working directories 
mkdir $PIRC_root $PIRC_root/tools $PIRC_root/sysadmin $PIRC_root/tmp $SRC_root $PIRC_log_dir 

###cvsup 
pkg_add -r cvsup-without-gui
hash;rehash
cd $PIRC_root
fetch ftp://$FTPSVR/cvs-supfile
cvsup cvs-supfile

###Extract the options files for building ports, wihtout the presence of subversion yet
mkdir $PIRC_root/tmp/untar
cd $PIRC_root/tmp/untar
fetch ftp://$FTPSVR/vardbports.tar
tar -xf vardbports.tar
cp -r _var_db_ports/ /var/db/ports
cd $PIRC_root/tmp
rm -rf $PIRC_root/tmp/untar

#make subversion - with some of above options
cd /usr/ports/devel/subversion; make install clean
hash;rehash

################ At this point I have a clean machine
################ so grab the build scripts and put in $SRC_root
cd $PIRC_root/tmp
svn export svn://svn/PIRC_IT/SysAdmin/BSD/NEW_BASE_SVR/ --force


### sysadmin
cd $SRC_root
/bin/sh setup_sysadmin.sh

#### python
# do python first as I may want to build install scripts with it later on
cd $SRC_root
/bin/sh setup_python.sh

#### sql
cd $SRC_root
/bin/sh setup_mysql.sh

####
cd $SRC_root
/bin/sh setup_apache.sh


############### workstation
cd /usr/ports/sysutils/screen; make install clean

### CLEAN UP AND FINISH
rm -r $PIRC_root/NEW_BASE_SVR

echo completed port_install > /etc/motd
