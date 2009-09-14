############################### USER VARIABLES ###############################
UNTAR=untar
VERSION=freebsd-7.1.0
FTPSVR=ftp.office.pirc.co.uk
PIRCTMP=/usr/local/PIRC/tmp/$UNTAR
REPO_DIR=/usr/ports/packages/All


PKG_LIST=""
PORTS_LIST="lang/python devel/py-lxml shells/bash sysutils/screen \
devel/subversion security/sudo www/apache22 devel/git \
databases/mysql51-server databases/mysql51-client databases/py-MySQLdb"



##############################################################################

echo "=> Starting pkg building"
mkdir -p $REPO_DIR

for PORT in $PORTS_LIST
do

cd /usr/ports/$PORT
PKG=`make package-name`
echo "==> discover $PORT is $PKG"

# visit the mirror of All, and crete packages recursively
# I could use make package-recursive but that then *builds* the ports too
cd $REPO_DIR
pkg_create -R -b $PKG

## keep the pkg names
PKG_LIST=$PKG_LIST\ $PKG

done

echo "pkg created "
echo \# $PORTS_LIST >> pkg_create.log
echo $PKG_LIST >> pkg_create.log

