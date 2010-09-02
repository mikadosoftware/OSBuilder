#!/usr/local/bin/python

'''
:author: pbrian


take a set (2!) templates and alter them to have the correct
data, and then write out to the correct jail location

The 'templates' are just text files holding what would be a python 
string ready for text formating. Just need to be careful of %%
 
'''
import subprocess
import commands
import sys

def configjail(hostname, ip):
    #sshd
    txt = open(SSHTMPL).read()
    fo = open('/usr/jail/%s/etc/ssh/sshd_config' % hostname, 'w')
    fo.write(txt)
    fo.close()

    #rc.conf
    txt = open(RCTMPL).read()
    fo = open('/usr/jail/%s/etc/rc.conf' % hostname, 'w')
    fo.write(txt % {'hostname': hostname, 'ip':ip} )
    fo.close()    

    #resolv.conf
    txt = open(RESOLVERTMPL).read()
    fo = open('/usr/jail/%s/etc/resolv.conf' % hostname, 'w')
    fo.write(txt)
    fo.close()

if __name__ == '__main__':
    ref      = sys.argv[1:][0] #'alcatraz2'
    hostname = sys.argv[1:][1] #'alcatraz2.office.pirc.co.uk'
    ip       = sys.argv[1:][2] #'10.137.1.112'
    RCTMPL   = 'rc.conf.tmpl'
    RESOLVERTMPL  = 'resolv.conf.tmpl'
    SSHTMPL  = 'sshd_config.tmpl'


    configjail(hostname, ip)


