#!/bin/bash
#
#	Patch script
#
CURDIR=$1
SHARELATEXROOT=$2
FILENAME=''
DIRNAME=""
# DIRNAME="./"

# update repository and tlmgr
tlmgr option repository http://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/	
if [ "$?" != "0" ]; then exit 1 ; fi
tlmgr update --self
if [ "$?" != "0" ]; then exit 2 ; fi

# exit successfully
exit 0


