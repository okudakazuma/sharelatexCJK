#!/bin/bash
#
#	Patch script
#
CURDIR=$1
SHARELATEXROOT=$2
FILENAME='LatexRunner.coffee'
DIRNAME="${SHARELATEXROOT}/clsi/app/coffee"
# DIRNAME="./"

# copy the target file
cp -f ${DIRNAME}/${FILENAME} ${CURDIR}/${FILENAME}.original
if [ "$?" = "1" ]; then exit 1 ; fi
# duplicate and create the tempolal file
cp -f ${CURDIR}/${FILENAME}.original ${CURDIR}/${FILENAME}.patched
if [ "$?" = "1" ]; then exit 2 ; fi

# debug option for sed command
# DEBUG="cat ${CURDIR}/${FILENAME}.patched"  # show result after each sed
DEBUG=""  # do not show result after each sed

# sed operation
sed -i -e "/command = LatexRunner._lualatexCommand mainFile/a HOGEHOGE1" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
grep "HOGEHOGE1" ${CURDIR}/${FILENAME}.patched &>/dev/null ; if [ "$?" = "1" ]; then exit 11 ; fi
sed -i -e "/HOGEHOGE1/i \\\t\telse if compiler == \"ctex\"" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \\\t\t\tcommand = LatexRunner._ctexCommand mainFile" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \\\t\telse if compiler == \"platex\"" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \\\t\t\tcommand = LatexRunner._platexCommand mainFile" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \\\t\telse if compiler == \"hlatex\"" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \\\t\t\tcommand = LatexRunner._hlatexCommand mainFile" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/d" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}

sed -i -e "/_lualatexCommand: (mainFile) ->/,/\]/s/\]/\]\nHOGEHOGE2/" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
grep "HOGEHOGE2" ${CURDIR}/${FILENAME}.patched &>/dev/null ; if [ "$?" = "1" ]; then exit 12 ; fi
sed -i -e "/HOGEHOGE2/s/HOGEHOGE2/\nHOGEHOGE2/" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE2/i \\\t_ctexCommand: (mainFile) ->" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE2/i \\\t\tLatexRunner._latexmkBaseCommand.concat \[" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE2/i \\\t\t\t\"-ctex\"," ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE2/i \\\t\t\tPath.join(\"\$COMPILE_DIR\", mainFile)" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE2/i \\\t\t\]" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE2/s/HOGEHOGE2/\nHOGEHOGE2/" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE2/i \\\t_platexCommand: (mainFile) ->" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE2/i \\\t\tLatexRunner._latexmkBaseCommand.concat \[" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE2/i \\\t\t\t\"-platex\"," ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE2/i \\\t\t\tPath.join(\"\$COMPILE_DIR\", mainFile)" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE2/i \\\t\t\]" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE2/s/HOGEHOGE2/\nHOGEHOGE2/" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE2/i \\\t_hlatexCommand: (mainFile) ->" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE2/i \\\t\tLatexRunner._latexmkBaseCommand.concat \[" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE2/i \\\t\t\t\"-hlatex\"," ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE2/i \\\t\t\tPath.join(\"\$COMPILE_DIR\", mainFile)" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE2/i \\\t\t\]" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE2/d" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}

# copy patched file to target
cp -f ${CURDIR}/${FILENAME}.patched ${DIRNAME}/${FILENAME}
if [ "$?" = "1" ]; then exit 3 ; fi

# exit successfully
exit 0

