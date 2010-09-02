#!/bin/sh

## author: pbrian
## brief: setup the std sysadmin setup on this server.

#### sysadmin
# TODO: 
cd /usr/ports/security/sudo; make install clean
cd /usr/ports/shells/bash; make install clean
#install sysadmin tools as needed
#use import crypt; crypt.crypt('mattpass2','ma') where salt is any two letters -
pw groupadd itdept

pw user add -n pbrian -m -G wheel,itdept -s /usr/local/bin/bash
chpass -p pbEe7jqSNHUXE pbrian
pw user add -n robc -m -G wheel,itdept -s /usr/local/bin/bash
chpass -p pbEe7jqSNHUXE robc

#set the correct time
ntpdate pool.ntp.org

#copy over the correct sudoers file
svn cat svn://svn/PIRC_IT/SysAdmin/BSD/COMPS/sysadmin_setup/sudoers > /usr/local/etc/sudoers
chmod 0440 /usr/local/etc/sudoers

######
hash;rehash
############# end sysadmin
