#!/bin/sh
#pbrian sept 06

### PIRCDOCS ###
# build and configure basic MySQL Service
#
#1. Build MySQL from ports 
#2. First Time configure, including
#   copy my.cnf, ensure start on boot, set root password
#3. location of important log files
#
### PIRCDOCS/ ###

### TEST FOR ENV
#if [ -z $PIRC_LOG_DIR ]; then
# exit 1
#fi

#build from ports
cd /usr/ports/databases/mysql50-server; make install clean > $installLogDir/mysql.install 2>&1


###
# by default, ports installs mysql into /usr/local 
# ie all bin files from mysql goto /usr/local/bin etc
# This is good.
# basedir is then /usr/local
# datadir is set by default in mysql.server to be /var/db/mysql
#
##

# my.cnf
cp $SRC_root/support/mysql/my.cnf /etc/my.cnf
#this is done by mysql_install_db anyway
#cp /usr/local/share/mysql/mysql.server /usr/local/etc/rc.d/

# use mysqlscripts to set up all needed dbases etc.
mysql_datadir=/usr/local/var/db/mysql
mkdir -p $mysql_datadir
chown mysql:mysql $mysql_datadir
/usr/local/bin/mysql_install_db --user=mysql --datadir=$mysql_datadir

#start up mysql manually.
#NB mysqld_safe is a script that runs the real binary 
#(/usr/local/libexec/mysqld) and restarts it if needed
cd /usr/local 
/usr/local/bin/mysqld_safe &
#wait till mysql has started up - cannot use wait as mysql is daemon
sleep 10

### ensure can run at start up
#alter rc.conf
echo \#Added Automatically by setup_mysql.sh >> /etc/rc.conf
echo mysql_dbdir="/usr/local/var/db/mysql" >> /etc/rc.conf 
echo mysql_enable="YES" >> /etc/rc.conf


#root password
/usr/local/bin/mysqladmin -u root password 'qwerty1'
/usr/local/bin/mysqladmin -u root -h `hostname` password 'qwerty1'
mysql -u root -pqwerty1 -e "GRANT ALL ON *.* TO 'pbrian'@'192.168.1.0/255.255.255.0' IDENTIFIED BY 'devpass';"
mysql -u root -pqwerty1 -e "GRANT ALL ON *.* TO 'backup'@'192.168.1.0/255.255.255.0' IDENTIFIED BY 'backpass';"
mysql -u root -pqwerty1 -e "GRANT ALL ON *.* TO 'dev'@'192.168.1.0/255.255.255.0' IDENTIFIED BY 'devpass';"


#also set up 
#log=/var/lib/mysql/generalquery.log
#on my.cnf (nb ensure mysql user has w access)
#also set up some logrotation - this is development stuff only.

#questions
#where is error log - $datadir/hostname.err
#where is sql log
#where is pid file - $datadir/hostname.pid

