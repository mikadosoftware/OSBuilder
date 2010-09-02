#!/usr/local/bin/python
# -*- coding: utf-8 -*-

"""
pbrian

we have a main config file holding a dictionary of 
jails and ips
   {alcatraz9: ['10.137.1.119', 'alcatraz9.office.pirc.co.uk'],


sh startjail.sh alcatraz$i 10.137.1.11$i

"""

import jail_config as jc
import subprocess
import tempfile
import os

def check_host_exists(fqdn):
    fd, outfile = tempfile.mkstemp()
    #get a file object
    fo = os.fdopen(fd)

    #check call succeeded?
    subprocess.call(["dig", fqdn], stdout=fo)
    fo.seek(0); results = fo.read(); fo.close; os.remove(outfile)

    if results.find(";; ANSWER SECTION:") == -1:
        #no answer, fqdn not exist
        return False
    else:
        return True


if __name__ == '__main__':
    CURRDIR = os.path.split(os.path.abspath(__file__))[0]
    jailcmd = os.path.join(CURRDIR, "startjail.sh")

    for jail_name in jc.startup_jails:
        jail_ip, jail_fqdn = jc.startup_jails[jail_name]

        if not check_host_exists(jail_fqdn):
            raise "No such FQDN as %s" % jail_fqdn
         
        cmd = ["/bin/sh", jailcmd, jail_fqdn, jail_ip]
        print cmd  
        subprocess.call(cmd)







