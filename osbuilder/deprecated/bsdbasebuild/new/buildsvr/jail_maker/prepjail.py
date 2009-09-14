#!/usr/local/bin/python

'''
:author: pbrian

This will prepare the host for jail duty.

1. Configure the sshd_config file so it only listens on the main IP
2. Set up whatever aliases we require
3. Fix the syslog and inted to avoid jail and host clashing

4. given a jail, append to rc.conf the appropriate settings


Some (all) of this can be awkward, so I may leave some parts for manual
 
'''
import sys
import datetime
import subprocess

def one_time_host_prep(**details):
    """Has this host ever been prepped for jails?
    if not do so,
 
    """
    #check if we have already prepped this rc.conf
    txt = open("/etc/rc.conf").read()
    if txt.find(ONETIME) != -1: 
        print "Do not prep host"
        return
    
    prep = """
###### Start One time prep of host by jail_maker %(time)s ######
%(ONETIME)s #This is a flag for jail_maker. Do not touch

sendmail_enable=="NONE" #turn off sendmail
inetd_flags=="wW -a %(host_ip)s" #only listen for host ip address
syslogd_flags=="-ss" #stop syslogd listening on network   

### Global Jail Settings
jail_enable="YES"
jail_list=""

###### End One Time host prep                             #######

"""  % {'time':datetime.datetime.today().strftime("%a %d %b %Y"),
        'host_ip':'10.137.1.40',
        'ONETIME':ONETIME}

    fo = open('/etc/rc.conf','a')
    fo.write(prep)
    fo.close()


def each_time_host_prep(**details):
    """Prep needed for each jail added.  
    Alter the jail_list and alter the aliases
    """
    rc_conf = ''

    ### this presents difficulties - getting machine to recognise an alias in rc.conf when 
    ### ruining netif.  I think a direct call to ifconfig first time will work

    ifconfig_ct = -1 # the first alias must be alias0, it fails otherwise ...    
    for line in open('/etc/rc.conf'):
        if line.find("ifconfig_") == 0:
            ifconfig_ct += 1

        if line.find('jail_list') == 0:
            jail_list = line[len('jail_list='):].replace('"','')
            print "Start", jail_list
            py_jail_list = jail_list.split()
            if details['jailname'] not in py_jail_list:
                #this host not in jail list, so add
                py_jail_list.append(details['jailname'])
            str_jail_list = 'jail_list="%s"\n' % " ".join(py_jail_list)
            
            rc_conf += str_jail_list
            print "End", str_jail_list
 
        else:
            rc_conf+=line
    
    ifconfig = "ifconfig_bge0"
    details['ifconfig_ct'] = ifconfig_ct
    ifconfig_alias = ifconfig + '_alias%(ifconfig_ct)s="inet %(ip)s netmask 255.255.255.255"' % details   
    ifconfig_alias_direct = "ifconfig bge0 inet %(ip)s netmask 255.255.255.255 alias" % details     

    fo = open('/etc/rc.conf','w')
    fo.write(rc_conf + ifconfig_alias)
    fo.close()


    print "================= run this ============="
    print ifconfig_alias_direct
    subprocess.call(ifconfig_alias_direct.split())
    print "now restart jails"

    
def configjail(**details):

    rc_conf_tmpl = """
## start config Jail %(jailname)s ##

jail_%(jailname)s_rootdir="/usr/jail/%(jailname)s"     # jail's root directory
jail_%(jailname)s_hostname="%(jailname)s.%(domain)s"  # jail's hostname
jail_%(jailname)s_ip="%(ip)s"           # jail's IP address
jail_%(jailname)s_procfs_enable="YES"          # mount procfs in the jail
jail_%(jailname)s_devfs_enable="YES"          # mount devfs in the jail

## End config Jail %(jailname)s ##

"""

    
    txt = rc_conf_tmpl
    fo = open('/etc/rc.conf', 'a')
    fo.write(txt % details)
    fo.close()



if __name__ == '__main__':
    hostname = sys.argv[1:][0] #'alcatraz2'
    ip       = sys.argv[1:][1] #'10.137.1.112'
    DOMAIN   = 'office.pirc.co.uk'
    ONETIME  = "#jail_maker has prepped this host#"
 
    one_time_host_prep()    
    each_time_host_prep(jailname=hostname, ip=ip, domain=DOMAIN)
    configjail(jailname=hostname, ip=ip, domain=DOMAIN)


