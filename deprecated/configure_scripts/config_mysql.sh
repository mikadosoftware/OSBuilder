#!/bin/sh

####################### Configure Default MySQL Server #######################
# Configure the MySQL installation
# 
#1. First Time configure, including
#   copy my.cnf, ensure start on boot, set root password
#3. location of important log files
#
##############################################################################

###### Bibliography and refs
#
#http://dev.mysql.com/doc/refman/5.0/en/unix-post-installation.html
#http://dev.mysql.com/doc/refman/5.0/en/installation-layouts.html
# http://ftp.uoi.gr/pub/databases/mysql/doc/refman/5.0/en/innodb-configuration.html

######### Notes
# We are installing the database files on 
# /usr/local/var/db/mysql   (datadir)
# we have NOT tuned innodb - todo

#### STAGING SERVER (we need to to this a lot more)
stg=/tmp/mysql.stg
mkdir -p $stg

# my.cnf
svn cat svn://svn/PIRC/projects/app_comps/trunk/sql/my.cnf > $stg/my.cnf
cp $stg/my.cnf /etc/my.cnf 


## Create /usr/local/tmp. This is the default tmp dir for mysql
mkdir -p /usr/local/tmp
chmod a+rw /usr/local/tmp

# use mysql.com own scripts to set up all needed dbases etc.
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
echo \#Added Automatically by config_mysql.sh >> /etc/rc.conf
echo mysql_dbdir="/usr/local/var/db/mysql" >> /etc/rc.conf 
echo mysql_enable=\"YES\" >> /etc/rc.conf


#root password
/usr/local/bin/mysqladmin -u root password 'qwerty1'
/usr/local/bin/mysqladmin -u root -h `hostname` password 'qwerty1'
mysql -u root -pqwerty1 -e "GRANT ALL ON *.* TO 'pbrian'@'10.137.0.0/255.255.0.0' IDENTIFIED BY 'devpass';"
mysql -u root -pqwerty1 -e "GRANT ALL ON *.* TO 'backup'@'10.137.0.0/255.255.0.0' IDENTIFIED BY 'backpass';"
mysql -u root -pqwerty1 -e "GRANT ALL ON *.* TO 'robc'@'10.137.0.0/255.255.0.0' IDENTIFIED BY 'devpass';"


#also set up 
#log=/var/lib/mysql/generalquery.log
#on my.cnf (nb ensure mysql user has w access)
#also set up some logrotation - this is development stuff only.

#questions
#where is error log - $datadir/hostname.err
#where is sql log
#where is pid file - $datadir/hostname.pid

