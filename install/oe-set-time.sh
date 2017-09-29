#!/bin/bash


# Verify we are running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

sed -i 's/date\.timezone\ =\ \"Europe\/London\"/date\.timezone\ =\ \"Australia\/Melbourne\"/' /etc/php/5.6/cli/php.ini;
sed -i 's/date\.timezone\ =\ \"Europe\/London\"/date\.timezone\ =\ \"Australia\/Melbourne\"/' /etc/php/5.6/apache2/php.ini;