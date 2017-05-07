#!/bin/bash
#
#	Patch script
#
CURDIR=$1
SHARELATEXROOT=$2
FILENAME=''
DIRNAME=""
# DIRNAME="./"

# install CJK collection
package_list=()
package_list+=("collection-langchinese")
package_list+=("collection-langjapanese")
package_list+=("collection-langkorean")
package_list+=("xetex")

for PACKAGE in ${package_list[@]}; do
  RET=`tlmgr info ${PACKAGE} | grep "installed" | sed -e 's/installed:   //'`
  if [ "${RET}" = "No" ]; then 
    tlmgr install ${PACKAGE}
    if [ "$?" = "1" ]; then exit 1 ; fi
  fi
done

# exit successfully
exit 0


