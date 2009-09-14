echo "=> Installing WebSVN (see http://www.ferdychristant.com/blog/archive/DOMM-6NGCCN)"

INSTALL_PATH = "/usr/local/www/apache22/data/"

echo "=> Creating the temporary source folder"
mkdir -p /tmp/websvn
cd /tmp/websvn

echo "=> Downloading"
curl -O -f http://websvn.tigris.org/files/documents/1380/39378/websvn-2.0.tar.gz
if [ $? = 22 ] ; then
    echo "=> ERROR. Unable to connect to url"
    exit
fi

echo "=> Extracting to $INSTALL_PATH"
tar xzvf websvn-2.0.tar.gz -C $INSTALL_PATH
cd websvn-2.0

echo "=> Now edit $INSTALL_PATH/websvn/includes/distconfig.inc to point to the repo"


echo "=> Done"