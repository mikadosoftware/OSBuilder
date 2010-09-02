#!/bin/sh
#
# author: pbrian
# brief: setup cups

cd /usr/ports/print/cups-base; make install clean
cd /usr/ports/print/cups; make install clean

#now enable cupsd in rc.conf
echo cupsd_enable="YES" >> /etc/rc.conf
#LPDEST=<my printer name>
#LPDEST=hp_color_LaserJet_4650_192.168.1.40
#export LPDEST
#start it manually, then download the appropriate ppd files from
#linuxprinting.org/download/ppd, install on http://localhost:631
#
#worry about rest later
