# pbrian sept 5
#installtion instructions for generic server
###
# 1. create a minimal freebsd server, using sysinstall.
#    add the correct hostnames etc, make it ssh compatible, also add a user "installer" with wheel group
# 2. then login (console ok) and fetch main_install_servertype.sh 
# 3. run that 

#######
# Expects an anonymous ftp server (pureftp is in KB) that holds cvsupfile.
# put this file in same location and fetch from minimal server then run this. 
# fetch ftp://192.168.1.10/install1.sh
#######

#CONSTANTS
FTPSVR=pbrian.office.pirc.co.uk
PIRC_root=/usr/local/PIRC
PIRC_log_dir=/usr/local/tmp/log
PIRC_this_hostname=pbrian2.office.pirc.co.uk # should use hostname but my little ' things are not working

### Export for rest of scripts to use
export PIRC_root
export PIRC_log_dir
export PIRC_this_hostname


#make working directories
mkdir $PIRC_root; mkdir $PIRC_root/tools; mkdir $PIRC_root/sysadmin; mkdir $PIRC_root/tmp
STG=/usr/local/PIRC/tmp
mkdir $STG/untar

#cvsup 
pkg_add -r cvsup-without-gui
hash;rehash
cd $STG
fetch ftp://$FTPSVR/cvs-supfile
cvsup cvs-supfile

#Extract the options files for building ports, wihtout the presence of subversion yet
cd untar
fetch ftp://$FTPSVR/vardbports.tar
tar -xf vardbports.tar
cp -r _var_db_ports/ /var/db/ports
cd $STG
rm -rf $STG/untar

#make subversion
cd /usr/ports/devel/subversion; make install clean
hash;rehash


################ At this point I have a clean machine, and need to fill it up
cd PIRC_root/tmp
svn export -N svn://svn/PIRC_IT/SysAdmin/BSD/NEW_BASE_SVR 

#### sysadmin
# TODO: 
cd /usr/ports/security/sudo; make install clean
cd /usr/ports/shells/bash; make install clean
#install sysadmin tools as needed
#use import crypt; crypt.crypt('mattpass2','ma') where salt is any two letters -
pw groupadd itdept

pw user add -n pbrian -m -G wheel,itdept -s /usr/local/bin/bash
chpass -p pbEe7jqSNHUXE pbrian

#set the correct time
ntpdate pool.ntp.org

#copy over the correct sudoers file
svn cat svn://svn/PIRC_IT/SysAdmin/BSD/COMPS/sysadmin_setup/sudoers > /usr/local/etc/sudoers
chmod 0440 /usr/local/etc/sudoers

######
hash;rehash
############# end sysadmin


#### python
# do python first as I may want to build install scripts with it later on
/bin/sh setup_python.sh


####
cd PIRC_root/tmp
/bin/sh setup_apache.sh
cd /usr/ports/www/apache22; make install clean


############### workstation
cd /usr/ports/x11/xorg;make install clean

cd /usr/ports/www/firefox; make install clean
cd /usr/ports/mail/thunderbird; make install clean
cd /usr/ports/x11-wm/enlightenment; make install clean
cd /usr/ports/security/gaim-encryption; make install clean
cd /usr/ports/net/samba3; make install clean
cd /usr/ports/net/sharity-light; make install clean
cd /usr/ports/net/vnc; make install clean
cd /usr/ports/net/rdesktop; make install clean
cd /usr/ports/sysutils/screen; make install clean
cd /usr/ports/graphics/xpdf; make install clean
cd /usr/ports/graphics/gimp; make install clean
cd /usr/ports/databases/mysql-query-browser; make install clean

###cups
cd /usr/ports/print/ghostscript-gnu && make install clean
cd /usr/ports/print/cups && make install clean



echo completed port_install > /etc/motd


### now we need to 
## config X
# Xorg -configure
# change modes "1280x1024" DefaultDepth 24
# cp /root/xorg.conf.new /etc/X11/xorg.conf
# /etc/ttys > on for tty8 (xdm)

