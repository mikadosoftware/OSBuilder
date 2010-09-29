#!/bin/sh

# every time we build from port, a pkg is created, and build info stored 
# in /var/db/pkgs
# distfiles in /usr/ports/disfiles
# options in /var/db/ports

#so we can build the pkgs using make package or a recursive version is pkg_create
#thus I specify the major pakages I want to build, and the pkg_create -R ensures that all the dependecy packages 
#are also built and stored in the major package directory

for i in bash-3.1.17 sudo-1.6.8.12_1 screen-4.0.2_4 subversion-1.4.0_1 python-2.
do
 echo $i
 mkdir /tmp/$(hostname)_pkgs/$i
 cd /tmp/$(hostname)_pkgs/$i
 pkg_create -Rb $i
done

