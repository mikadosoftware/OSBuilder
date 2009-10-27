#!/usr/local/bin/python

'''
:author: pbrian


take a set of templates and alter them to have the correct
data, and then write out to the correct jail location

The 'templates' are just text files holding what would be a python 
string ready for text formating. Just need to be careful of %%

TODO
----

- validate inputs (ie check dotted notation for ip addr)
- more of this - this is really a bombe.  So what about fw? 
  what about time zones etc.
 
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

def initial_setup(hostname, ip):
    """Create in a sh file what we watnt o do to the jail, for example ntpdate """
    tmpl = open(INITIAL_TMPL).read()
    fo = open('/usr/jail/%s/etc/initial_setup.sh' % hostname, 'w')
    fo.write(tmpl)
    fo.close()
    print "run /etc/initial_setup.sh on first jexec"

if __name__ == '__main__':

    hostname = sys.argv[1:][0] #'alcatraz2'
    ip       = sys.argv[1:][1] #'10.137.1.112'

    RCTMPL   = 'config/rc.conf.tmpl'
    RESOLVERTMPL  = 'config/resolv.conf.tmpl'
    SSHTMPL  = 'config/sshd_config.tmpl'
    INITIAL_TMPL = 'config/initial.tmpl'

    configjail(hostname, ip)
    initial_setup(hostname, ip)

