#!/usr/local/bin/python

"""
   JID  IP Address      Hostname                      Path
     2  10.137.1.45     belmarsh5.office.pirc.co.uk   /usr/jail/belmarsh5
     1  10.137.1.44     belmarsh4.office.pirc.co.uk   /usr/jail/belmarsh4

"""

import subprocess
import sys

def parse_jid(line):
    cols = line.split()
    return cols[0]


def get_JID(jailname):

    ### from manual....
    x = subprocess.Popen(["jls"], stdout=subprocess.PIPE)
    output = x.communicate()[0]

    output_lines = output.split("\n")
    for line in output_lines:
        if line.find(jailname) != -1:
            jid = parse_jid(line)
            return jid
    return 0

def shutdown_jail(jid, jailname):
    subprocess.call(['jexec', jid, '/bin/sh', '/etc/rc.shutdown'])
    subprocess.call(['/etc/rc.d/jail', 'stop', jailname])

def chflags_jail(jailname):
    """umount /usr/jail/$HOST/dev
    umount /usr/jail/$HOST/proc
    chflags -R 0 /usr/jail/$HOST
    rm -rf /usr/jail/$HOST
    """

    subprocess.call(['chflags', '-R', '0', '/usr/jail/%s' % jailname])
#    subprocess.call(['umount', '/usr/jail/%s/devfs' % jailname])
#    subprocess.call(['umount', '/usr/jail/%s/proc' % jailname])
    subprocess.call(['rm', '-r', '-f', '/usr/jail/%s' % jailname])


if __name__ == '__main__':
    jailname = sys.argv[1:][0] 

    jid = get_JID(jailname)
    print "about to shutdown %s %s" % (jid, jailname)
    
    shutdown_jail(jid, jailname)
    chflags_jail(jailname)
