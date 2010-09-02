#!/bin/sh

# install the subversion port
cd /usr/ports/devel/subversion
echo "Installing Subversion..."
make -s -DWITH_SVNSERVE_WRAPPER install && make clean
hash


# setup the rc.d file
rm -f /usr/local/etc/rc.d/svn.sh
echo 'case "$1" in
start)
         echo -n " SVN Server"
        /usr/local/bin/svnserve -r /usr/local/PIRC/svn -d --listen-host $(hostname)
        ;;
stop)
        /usr/bin/killall svnserve
        echo -n " SVN Server"
        ;;
*)
        echo "Usage: `basename $0` {start|stop}" >&2
        ;;
esac
exit 0' > /usr/local/etc/rc.d/svn.sh

mkdir -p /usr/local/PIRC/tmp

# restore the backup
cd /usr/local/PIRC/tmp
echo "Fetching backup file from BKP..."
echo "(... this is over a gig, and takes a while, so don't lose hope if nothing much appears to be going on....)"
scp root@BKP:/BACKUP/NAGIOS/BACKUPsvn.gz .

echo "Unpacking backup file..."
gzip -df BACKUPsvn.gz

echo "Restoring backup..."
rm -rf /usr/local/PIRC/svn

/usr/local/bin/svnadmin create /usr/local/PIRC/svn
/usr/local/bin/svnadmin load -q /usr/local/PIRC/svn < BACKUPsvn 

# start subversion now
/usr/local/bin/svnserve -r /usr/local/PIRC/svn -d --listen-host $(hostname)

# last step - retrive the SVN backup script from within SVN itself, place in /root/, and add a cron job to execute it
svn cat svn://svn/PIRC/projects/service_core_servers/trunk/svn_backup/backup.sh > /root/backup.sh
chown root /root/backup.sh

echo "#added by deploy_compssql" >> /etc/crontab
echo "4      15       *       *       *       root    python /root/backup.sh > /var/log/SVNbackup.log" >> /etc/crontab



