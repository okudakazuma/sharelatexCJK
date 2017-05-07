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
cd ${SHARELATEXROOT}
grunt install | grep --line-buffered -e "ERR" -e "Finished" -e "Running" -e "Done"
if [ "$?" = "1" ]; then exit 1 ; fi	

# exit successfully
exit 0


