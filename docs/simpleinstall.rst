Install
=======

We download *memstick* img from FreeBSD, and we *dd* it to a USB stick

We boot from the USB stick, and install as normal

We then tarball over the FreeBSDFool scripts, build from there.


fetch -o ~/Downloads/r9.1.img ftp://ftp.freebsd.org/pub/FreeBSD/releases/amd64/amd64/ISO-IMAGES/9.1/FreeBSD-9.1-RELEASE-amd64-memstick.img ~/downloads/

fetch ftp://ftp.freebsd.org/pub/FreeBSD/releases/amd64/amd64/ISO-IMAGES/9.1/CHECKSUM.MD5 


dd if=FreeBSD-9.1-RELEASE-amd64-memstick.img of=/dev/da0 bs=10240 conv=sync


updates
-------

portsnap fetch extract
portsnap fetch update

freebsd-update fetch 
freebsd-update install


