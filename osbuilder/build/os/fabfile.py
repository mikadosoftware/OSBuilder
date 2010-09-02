#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import with_statement

from fabric.api import *
from fabric.state import env
from fabric import decorators
from fabric import contrib

env.description = 'Application Server Installation'
env.hosts = ['belmarsh6.office.pirc.co.uk']
env.user = 'root'
env.shell = 'bash'
env.svn_repo = "svn/PIRC/projects"

def deploy_apache():
    """Install and configure a standard apache22 server"""
    
    local("echo 'Installing apache22'")
    local("PACKAGESITE=ftp://ftp/PACKAGES/freebsd-7.1.0/; export PACKAGESITE")
    with warnings_only():
        result = local("pkg_add -r apache-2.2.11_4.tbz")
    local("chown -R www:www /usr/local/www/apache22/cgi-bin")
    local("chmod -R 0744 /usr/local/www/apache22/cgi-bin")
    local("unsetenv PACKAGESITE")

def start_apache():
    run("apachectl graceful")

def stop_apache():
    run("apachectl stop")


def deploy_mysql():
    """Install and configure a standard mysql5.1 server"""
    local("echo 'Installing mysql 5.1'")
    local("PACKAGESITE=ftp://ftp/PACKAGES/freebsd-7.1.0/; export PACKAGESITE")
    with warnings_only():
        result = local("pkg_add -r mysql-server-5.1.34.tbz")
    local("unsetenv PACKAGESITE")


def deploy_nginx():
    """Install and configure nginx with default PIRC proxy setup"""
    pass



