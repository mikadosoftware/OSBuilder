#!/bin/sh

## author: pbrian
## brief: setup python from ports and cherrypy, cheetah, docutils from our svn repository

## INSTALL PYTHON (FROM PORTS)
cd /usr/ports/lang/python; make install clean

## INSTALL PYTHON-MYSQL (FROM PORTS)
cd /usr/ports/databases/py-MySQLdb; make install clean

ln -s /usr/local/lib/python2.4/ /usr/local/lib/python

## EXPORT PPP FROM SVN TO SITE-PACKAGES
cd /usr/local/lib/python/site-packages
svn export svn://svn/PIRC_IT/SysAdmin/BSD/PythonLibrary/ppp

## MOVE OVER THE PYTHON SUPPORT FILES FROM SVN TO PIRC_ROOT/TMP/

## INSTALL CHERRYPY (FROM SOURCE)
cd $SRC_root/support/python/cherrypy
tar -xzvf CherryPy-2.2.1.tar.gz
cd CherryPy-2.2.1
python setup.py install

## INSTALL CHEETAH (FROM SOURCE)
cd $SRC_root/support/python/Cheetah-2.0rc7
python setup.py install

# INSTALL DOCUTILS (FROM SOURCE)
cd $SRC_root/support/python/
tar -xzvf docutils-0.4.tar.gz
cd docutils-0.4
python setup.py install
python tools/buildhtml.py --config=tools/docutils.conf
cp -r ../docutils-0.4 /usr/local/PIRC/tools/

