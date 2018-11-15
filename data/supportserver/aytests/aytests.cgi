#!/bin/bash
# do some variable expansion in autoyast profiles during download
FILE=${REQUEST_URI#/aytests/}
[ ! -f "/srv/www/htdocs/aytests/$FILE" ] && exit 1

# use real VM's MAC addres to test udev rules
MAC=$( echo $( arp -n | grep "^$REMOTE_ADDR " ) | cut -d ' ' -f 3 )
[ -z "$MAC" ] && exit 1
echo "replacing MAC '$MAC' in '$FILE'" > /dev/stderr

echo "Content-type: text/xml"
echo
sed -e "s|{{MAC1}}|$MAC|g" "/srv/www/htdocs/aytests/$FILE"
