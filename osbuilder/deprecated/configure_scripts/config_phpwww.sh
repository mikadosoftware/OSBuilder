#!/bin/sh

echo "==> Configuring basic apache install"
echo #enable apache - added by config_phpwww.sh >> /etc/rc.conf
echo apache_enable=\"YES\" >> /etc/rc.conf

###
#configure httpd for php
# hconf=/usr/local/etc/apache/httpd.conf
# echo "" >> $hconf
# echo "### enable php in httpd.conf added by config_phpwww.sh" >> $hconf
# echo "    <IfModule mod_php5.c>                             " >> $hconf
# echo "     DirectoryIndex index.php index.html              " >> $hconf
# echo "    </IfModule>                                       " >> $hconf 
# echo "    <IfModule mod_php5.c>                             " >> $hconf
# echo "     AddType application/x-httpd-php .php             " >> $hconf 
# echo "     AddType application/x-httpd-php-source .phps     " >> $hconf 
# echo "    </IfModule>                                       " >> $hconf  


echo "==> Starting apache"
/usr/local/etc/rc.d/apache.sh start

