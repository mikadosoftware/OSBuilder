#!/bin/sh

##########
# pbrian
# To automate the process of building ports, from scratch
# I only do this to make the config-recursive thing bearable
# I should have a copy of the /var/db/ports/xxx/options

# keep different files with lists of desirable ports
# import those files, by importing the first argument

### useage
### port_builder.sh list_basics.sh
### where list_basics.sh has a bash variable of form
### list="lang/python lang/perl"

. $1

#logging and constants
FOLDER=`pwd`/..
LOGFOLDER=$FOLDER/log
log=$LOGFOLDER/buildports.log
dd="date +%FT%H:%M:%S" 


for x in $list
do

cd /usr/ports/$x
make config-recursive

done

for x in $list
do

echo `$dd` Starting $x >> $log
cd /usr/ports/$x
make install clean 2>&1 /usr/ports/$x/buildlog.log 

done

echo `$dd` Fin. >> $log



