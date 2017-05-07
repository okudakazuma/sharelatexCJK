#!/bin/bash
#
#	Patch script
#
CURDIR=$1
SHARELATEXROOT=$2
FILENAME=''
DIRNAME=""
# DIRNAME="./"

# install kerberos
PACKAGE='libkrb5-dev'
dpkg -l ${PACKAGE} &>/dev/null
if [ "$?" = "0" ]; then exit 1 ; fi
DEBIAN_FRONTEND=noninteractive apt-get -y install ${PACKAGE} &>/dev/null
if [ "$?" = "1" ]; then exit 2 ; fi

# exit successfully
exit 0


