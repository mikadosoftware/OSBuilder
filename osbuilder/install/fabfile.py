#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Deployment recipes for mysql and apache servers.
"""

from __future__ import with_statement

import socket, time
from fabric.api import *
from fabric.state import env
from fabric.context_managers import settings, hide
from fabric import decorators
from fabric import contrib

env.description = 'Application Server Installation'
env.user = 'root'
env.shell = 'bash'
env.svn_repo = "svn://svn/PIRC/projects"
env.packagesite = "ftp://ftp/PACKAGES/freebsd-7.1.0/"


def _process_conf(confpath, directive):
    """Ensure that the conf file at confpath contains the string 
    'directive'. It simply appends the directive to the file.
    """
    infile = local("cat %s" % confpath)
    if directive not in infile:
        local("echo %s >> '%s'" % (directive, confpath))

def _wait(interval):
    time.sleep(interval)

def install_apache():
    """Install and configure a standard apache22 server"""
    
    local("echo 'Installing apache22'")
    pkgsite = "PACKAGESITE=%s; export PACKAGESITE" % env.packagesite
    with settings(hide('warnings'), warn_only=True):
        local("%s;pkg_add -r apache-2.2.11_4.tbz" % pkgsite)
    local("chown -R www:www /usr/local/www/apache22/cgi-bin")
    local("chmod -R 0744 /usr/local/www/apache22/cgi-bin")
    _process_conf("/etc/rc.conf", 'apache_enable=YES')
    local("unset PACKAGESITE")

def start_apache():
    run("apachectl graceful")

def stop_apache():
    with virtualenv('path/to/virtualenv/'):
        run("apachectl stop")
    
    with env_variables({'PYTHONPATH': '/path/to/virtualenv'}):
        run("apachectl stop")


def install_mysql():
    """Install and configure a standard mysql5.1 server"""
    env.datadir = "/usr/local/var/db/mysql"
    env.root_password = 'qwerty1'
    
    stop_mysql()
    
    local("PACKAGESITE=%s; export PACKAGESITE" % env.packagesite)
    pkgsite = "PACKAGESITE=%s; export PACKAGESITE" % env.packagesite
    with settings(hide('warnings'), warn_only=True):
        local("%s;pkg_add -r mysql-server-5.1.34.tbz" % pkgsite)
    
    ##TODO: Move this file to a more appropriate svn repo    
    local("svn cat %s/build_system/trunk/install/my.cnf > /etc/my.cnf" % env.svn_repo)
    local("rm -rf %s" % env.datadir)
    local("mkdir -p %s" % env.datadir)
    local("chown mysql:mysql %s" % env.datadir)
    local("/usr/local/bin/mysql_install_db --user=mysql --datadir=%s" % env.datadir)
    _process_conf("/etc/rc.conf", "mysql_enable=YES")
    _process_conf("/etc/rc.conf", 'mysql_dbdir=/usr/local/var/db/mysql')
    
    local("/usr/local/etc/rc.d/mysql-server start")
    
    ## Setup root access
    with settings(hide('warnings'), warn_only=True):
        local("/usr/local/bin/mysqladmin -u root password '%s'" % env.root_password)
    
    ## TODO: REPLACE WITH file in svn
    local('''mysql -u root -pqwerty1 -e "GRANT ALL ON *.* TO 'pbrian'@'10.137.0.0/255.255.0.0' IDENTIFIED BY 'devpass';"''')
    local('''mysql -u root -pqwerty1 -e "GRANT ALL ON *.* TO 'backup'@'10.137.0.0/255.255.0.0' IDENTIFIED BY 'backpass';"''')
    local('''mysql -u root -pqwerty1 -e "GRANT ALL ON *.* TO 'robc'@'10.137.0.0/255.255.0.0' IDENTIFIED BY 'devpass';"''')
    local("mysqladmin flush-privileges -u root -p%s" % env.root_password)
    
    start_mysql()
    local("unset PACKAGESITE")

def start_mysql():
    local("/usr/local/etc/rc.d/mysql-server restart")
    _wait(4)

def stop_mysql():
    with settings(hide('warnings'), warn_only=True):
        local("/usr/local/etc/rc.d/mysql-server stop")
        _wait(4)


def install_nginx():
    """Install and configure nginx with default PIRC proxy setup"""
    pass

