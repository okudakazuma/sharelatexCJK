#!/bin/bash
#
#	Patch script
#
CURDIR=$1
SHARELATEXROOT=$2
FILENAME='pdfRenderer.coffee'
DIRNAME="${SHARELATEXROOT}/web/public/coffee/ide/pdfng/directives"
# DIRNAME="./"

# copy the target file
cp -f ${DIRNAME}/${FILENAME} ${CURDIR}/${FILENAME}.original
if [ "$?" = "1" ]; then exit 1 ; fi
# duplicate and create the tempolal file
cp -f ${CURDIR}/${FILENAME}.original ${CURDIR}/${FILENAME}.patched
if [ "$?" = "1" ]; then exit 2 ; fi

# debug option for sed command
#DEBUG="cat ${CURDIR}/${FILENAME}.patched"  # show result after each sed
DEBUG=""  # do not show result after each sed

# sed operation
sed -i -e "s/window.PDFJS.cMapUrl = '.\/bcmaps\/'/HOGEHOGE1/" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
grep "HOGEHOGE1" ${CURDIR}/${FILENAME}.patched &>/dev/null ; if [ "$?" = "1" ]; then exit 11 ; fi
sed -i -e "s/HOGEHOGE1/window.PDFJS.cMapUrl = '..\/bcmaps\/'/" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}

# copy patched file to target
cp -f ${CURDIR}/${FILENAME}.patched ${DIRNAME}/${FILENAME}
if [ "$?" = "1" ]; then exit 3 ; fi

# exit successfully
exit 0

