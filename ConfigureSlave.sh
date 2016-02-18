#!/bin/bash
#slave node configuration

#check if user is root
if [[ $USER != "root" ]]; then
echo "Run script as root"
exit 1
fi

