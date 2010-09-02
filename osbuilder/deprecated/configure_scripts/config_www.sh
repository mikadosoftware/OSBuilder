#!/bin/sh

###
echo #enable apache - added by config_www.sh >> /etc/rc.conf
echo apache_enable=\"YES\" >> /etc/rc.conf

##start apache
/usr/local/etc/rc.d/apache.sh start

echo config_www.sh completed >>/etc/motd
