#!/bin/sh
grep="/usr/bin/grep"
cut="/usr/bin/cut"
uptime="/usr/bin/uptime"
netstat="/usr/bin/netstat"
awk="/usr/bin/awk"
# netstat name interface
name=$1
iface=$2
$netstat -bI $iface | $grep "<Link#.*>" | $awk -F" " '{print $7"\n"$10}'
$uptime | $awk -F"up " '{print $2}' #| $cut -d"," -f1,2
echo $name

