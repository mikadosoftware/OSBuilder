############################### USER VARIABLES ###############################
UNTAR=untar
VERSION=freebsd-7.1.0
FTPSVR=ftp.office.pirc.co.uk
PIRCTMP=/usr/local/PIRC/tmp/$UNTAR
REPO_DIR=/usr/ports/packages/All

### This is manually generated for now.
### need to parse Makefile in ports but read porter handbook chp 5 - bit complex
PKG_LIST="apache-2.2.11_4 apr-gdbm-db42-1.3.3.1.3.4_1 bash-4.0.10_2 \
git-1.6.2.2 mysql-client-5.1.33 python-2.5,2 py25-MySQLdb-1.2.2 \
py25-lxml-2.2 subversion-1.6.0_2 sudo-1.6.9.20"



PKG_LIST=""
PORTS_LIST="lang/python devel/py-lxml shells/bash sysutils/screen devel/subversion security/sudo www/apache22 devel/git databases/mysql51-server databases/mysql51-client databases/py-MySQLdb"



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

