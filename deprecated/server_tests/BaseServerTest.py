########################################################################
#                                                                      #
#                    Server Base Install Test Suite                    #
#                                                                      #
#                                                                      #
########################################################################

"""
TODO
----

 * Move to a testing framework that allow conditional tests
 * Implement platform dependent tests
"""

import commands
import datetime
import os
import re
import socket
import struct
import sys
import time
import unittest


class NetworkTest(unittest.TestCase):
    def setUp(self):
        self.known_ip = '10.137.1.7'
        self.valid = (10, 137, 1, '*')
        
    
    def test_ip(self):
        """Check the IP is within the range 10.137.1."""
        ##Todo: Improve this check
        ip = socket.gethostbyname(socket.gethostname())
        ip = [int(i) for i in ip.split('.')]
        assert len(ip) == 4
        assert ip[0] == 10
        assert ip[1] == 137
        assert ip[2] == 1
        assert ip[3] >= 1 and ip[3] <= 255
    
    def test_ping(self):
        """Check that we can ping a known ip (vpn)"""
        status, output = commands.getstatusoutput('ping -c 5 %s' % self.known_ip)
        assert status == 0


class DateTimeTest(unittest.TestCase):
    """Check that current date and time are within defined ranges"""
    time_server_ip = '194.106.56.98' ##freedom2surf ntp server
    
    def setUp(self):
        self.ntp_server = NTPServer(self.time_server_ip)
        self.machine_date = datetime.datetime.now()
        self.actual_date = self.ntp_server.get_time()
    
    def test_datetime(self):
        """Assert difference between machine time and actual time is less than 20 seconds"""
        diff = self.machine_date - self.actual_date < datetime.timedelta(0, 20, 0)
        

class ExecutablesTest(unittest.TestCase):
    expected_executables = ['grep', 'ls', 'flip', 'ee', 'ping',
                            'svn', 'sudo', 'su', 'screen', 'svn', 'curl']
    
    def setUp(self):
        self.paths = filter(os.path.exists, os.environ.get('PATH').split(':') )
    
    def test_apps(self):
        """Check that the expected apps are available in $PATH"""
        ## List the dirs in PATH
        apps = []
        for path in self.paths:
            apps.extend(os.listdir(path))
            
        for app in self.expected_executables:
            assert app in apps


class PackagesTest(unittest.TestCase):
    expected_packages = ['apr-db42', 'gettext', 'libiconv', 
                         'libssh2', 'libtool', 'subversion']
 
    def setUp(self):
        # Redirecting stdout as pkg_info spews crap which annoys me
        self.stdout = sys.stdout
        sys.stdout = open('/dev/null', 'w')
 
    def test_packages(self):
        """Check that the expected packages are installed"""
        for pkg in self.expected_packages:
            status, output = commands.getstatusoutput('pkg_info -qx %s' % pkg)
            assert status == 0
 
    def tearDown(self):
        # Reset sys.stdout
        sys.stdout = self.stdout



class PythonModulesTest(unittest.TestCase):
    expected_modules = ['pysvn', 'MySQLdb', 'paramiko']
    
    def test_modules(self):
        """Check that expected modules are importable.
        NOTE: This function tries to import the module. This may have unforeseen consequences
        """
        for mod in self.expected_modules:
            try:
                __import__(mod)
            except ImportError:
                raise
            
class ConfigurationTest(unittest.TestCase):
    def setUp(self):
        self.inetd_conf = open('/etc/inetd.conf').readlines()
        self.rc_conf = dict( [line.strip().split('=') for line in open("/etc/rc.conf") if line.strip()] )
    
    def test_inetd(self):
        """Ensure that no service is enabled in /etc/inetd.conf"""
        uncommented_lines = [line for line in self.inetd_conf if not line.startswith('#')]
        assert not uncommented_lines
    
    def test_keyboard(self):
        """Check that the keyboard mappiong and rate are correct"""
        ## Note that the enclosed double-quotes are important. They are part of the config syntax
        assert self.rc_conf.has_key('keymap')
        assert self.rc_conf['keymap'] == '"uk.cp850"'
        assert self.rc_conf['keyrate'] == '"fast"'
    
    def test_default_router(self):
        """Check that default router is what we expect"""
        assert self.rc_conf.has_key('defaultrouter')
        assert self.rc_conf['defaultrouter'] == '"10.137.1.7"'
        
    def test_ssh(self):
        """Check that sshd is enabled correctly"""
        assert self.rc_conf.has_key('sshd_enable')
        assert self.rc_conf['sshd_enable'] == '"YES"'
        sshd_conf = open('/etc/ssh/sshd_config').read()
        assert re.search('[^#]PermitRootLogin yes', sshd_conf)
    
    def test_sendmail(self):
        """Check that sendmail is turned off completely"""
        assert self.rc_conf.has_key('sendmail_enable')
        assert self.rc_conf['sendmail_enable'] == '"NONE"'



class NTPServer(object):
    """With a nod to http://maxinbjohn.blog.com/2366141/"""
    EPOCH = 2208988800L
    def __init__(self, ip):
        self.server_addr = ip
    
    def get_time(self):
        client = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        data = '\x1b' + 47 * '\0'
        try:
            client.sendto(data, (self.server_addr, 123))
            data, address = client.recvfrom(1024)
            
            if data:
                #print 'Response received from:', address
                t = struct.unpack('!12I', data)[10]
                t -= self.EPOCH ## seconds since epoch
                #print '\tTime=%s' % time.ctime(t)
                return datetime.datetime.fromtimestamp(t)
        except socket.gaierror:
            #print "==> Network error"
            raise
        except socket.error:
            #print "==> Socket Error"
            raise
        

if __name__ == '__main__':
    unittest.main()
