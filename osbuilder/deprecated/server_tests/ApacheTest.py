########################################################################
#                                                                      #
#                      Apache Install Test Suite                       #
#                                                                      #
#                                                                      #
########################################################################

class TestApacheSetup(unittest.TestCase):
    """Check the setup of apache and apache modules"""
    def setUp(self):
        self.httpd_conf = open('/usr/local/etc/apache/httpd.conf')
    
    def test_apache_boot(self):
        """Check that apache is set to launch at boot time"""
        rc_conf = open('/etc/rc.conf').read()
        patt = re.compile('[\s]*apache_enable="YES"[\s]*')
        self.assert_(patt.search(rc_conf))
    
    def test_server_info(self):
        """Check that server-info is enabled in httpd.conf"""
        ## RE to match each section (excluding comment #)
        self.failUnless(False)
    
    def test_server_status(self):
        """Check that server-status is enabled in httpd.conf"""
        self.assert_(False)
    
    def test_php5(self):
        """Check that mod_php5 is enabled in httpd.conf"""
        self.assert_(False)