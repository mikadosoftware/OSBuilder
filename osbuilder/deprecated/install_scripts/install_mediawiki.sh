#!/bin/sh

tmp=/usr/local/PIRC/tmp
tarball=pircwiki-1.0.tgz

echo "=> Installing MediaWiki"

echo "=> Creating the source folder"
mkdir -p $tmp
cd $tmp

echo "==> Fetching Package"
fetch ftp://ftp/misc/$tarball

echo "==> Unpacking"
tar -xzf $tarball
cd wiki

echo "==> Installing with pkg_add"
pkg_add mediawiki-1.12.0_1.tbz

echo "==> Setting temporary dir permissions"
chmod a+rw /usr/local/www/mediawiki/config

echo "==> Configure apache (php5, aliases)"
cat >> /usr/local/etc/apache/httpd.conf << EOF

### Mediawiki settings ###

<IfModule mod_php5.c>
    AddType application/x-httpd-php .php
    AddType application/x-httpd-php-source .phps
</IfModule>

DirectoryIndex index.php index.php5 index.html

Alias /mediawiki/ "/usr/local/www/mediawiki/"
Alias /wiki/      "/usr/local/www/mediawiki/index.php/"
Alias /wiki       "/usr/local/www/mediawiki/index.php/"

<Directory /usr/local/www/mediawiki>
     Options MultiViews
     # allow sub-directories to restrict usage via .htaccess
     AllowOverride Limit
     Order allow,deny
     Allow from all
</Directory>
<Directory /usr/local/www/mediawiki/images>
     Options MultiViews
     AllowOverride None
     Order allow,deny
     Allow from all
     # avoid execution of PHP scripts in upload directory
     <FilesMatch "\.phps?$">
          AddHandler None .php .phps
          ForceType text/plain
     </FilesMatch>
</Directory>
EOF

echo "==> MANUAL STEP: ADD THE FOLLOWING TO LocalSettings.php in the mediawiki root after configuration"
echo "## Added in accordance with http://www.mediawiki.org/wiki/Manual:Short_URL"
echo "$wgArticlePath = '/wiki/$1';"
echo "$wgUsePathInfo = true;"
echo "==> ALSO REMEMBER TO MAKE CONFIG DIR READ ONLY"

echo "=> Done"