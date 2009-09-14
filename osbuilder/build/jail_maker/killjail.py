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
    return None

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
    subprocess.call(['umount', '/usr/jail/%s/devfs' % jailname])
    subprocess.call(['umount', '/usr/jail/%s/proc' % jailname])
    subprocess.call(['rm', '-r', '-f', '/usr/jail/%s' % jailname])

def clean_up_rcconf(jailname, JID):
    """I am killing off a jail, so I want to clear off the stuff from rc.conf """
    ststr = '''## start config Jail %s ##''' % jailname
    endstr = '''## End config Jail %s ##''' % jailname
    rc_txt = open("/etc/rc.conf").read()
    stidx = rc_txt.find(ststr)
    endidx = rc_txt.find(endstr) + len(endstr)
    new_rc = rc_txt[:stidx] + rc_txt[endidx:]
    fo = open('/etc/rc.conf.old', 'w'); fo.write(rc_txt);fo.close()
    fo = open('/etc/rc.conf', 'w'); fo.write(new_rc);fo.close()




if __name__ == '__main__':
    jailname = sys.argv[1:][0] 

    jid = get_JID(jailname)
    print "about to shutdown %s %s" % (jid, jailname)

    if jid != None:
        shutdown_jail(jid, jailname)

    chflags_jail(jailname)
    clean_up_rcconf(jailname, jid)
