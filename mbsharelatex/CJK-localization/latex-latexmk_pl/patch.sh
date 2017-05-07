#!/bin/bash
#
#	Patch script
#
CURDIR=$1
SHARELATEXROOT=$2
FULLPATH=`which latexmk | xargs readlink -f`
FILENAME=`basename ${FULLPATH}`
#FILENAME="latexmk.pl"
DIRNAME=`dirname ${FULLPATH}`
#DIRNAME="./"

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
sed -i -e "/elsif (\/\\^\-xelatex\\$\\/)/,/\}/s/\}/\}\nHOGEHOGE1/" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
grep "HOGEHOGE1" ${CURDIR}/${FILENAME}.patched &>/dev/null ; if [ "$?" = "1" ]; then echo hoge ; exit 12 ; fi
sed -i -e "/HOGEHOGE1/i \ \ elsif (\/\\^-ctex\\$\\/)      \{" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \ \ \ \ \ \ \\$\latex     = 'ctex %O %S';" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \ \ \ \ \ \ \\$\biber     = 'biber --bblencoding=utf8 -u -U --output_safechars %O %B';" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \ \ \ \ \ \ \\$\dvipdf    = 'dvipdfmx %O -o %D %S';" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
# sed -i -e "/HOGEHOGE1/i \ \ \ \ \ \ \\$\dvipdf    = 'dvipdfmx -f \/var\/www\/sharelatex\/texfonts.map %O -o %D %S';" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \ \ \ \ \ \ \\$\makeindex = 'mendex %O -o %D %S';" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \ \ \ \ \ \ \\$\pdf_mode  = 3;" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \ \ \}" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \ \ elsif (\/\\^-platex\\$\\/)      \{" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \ \ \ \ \ \ \\$\latex     = 'platex -shell-escape %O %S';" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \ \ \ \ \ \ \\$\bibtex    = 'pbibtex %O %B';" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \ \ \ \ \ \ \\$\biber     = 'biber --bblencoding=utf8 -u -U --output_safechars %O %B';" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \ \ \ \ \ \ \\$\dvipdf    = 'dvipdfmx %O -o %D %S';" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
# sed -i -e "/HOGEHOGE1/i \ \ \ \ \ \ \\$\dvipdf    = 'dvipdfmx -f \/var\/www\/sharelatex\/texfonts.map %O -o %D %S';" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \ \ \ \ \ \ \\$\makeindex = 'mendex %O -o %D %S';" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \ \ \ \ \ \ \\$\pdf_mode  = 3;" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \ \ \}" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \ \ elsif (\/\\^-hlatex\\$\\/)      \{" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
# under cording
sed -i -e "/HOGEHOGE1/i \ \ \ \ \ \ \\$\pdf_mode = 3;" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
#sed -i -e "/HOGEHOGE1/i \ \ \ \ \ \ \\$\dvi_mode = \\$\postscript_mode = 0; " ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/i \ \ \}" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}
sed -i -e "/HOGEHOGE1/d" ${CURDIR}/${FILENAME}.patched ;  ${DEBUG}

# copy patched file to target
cp -f ${CURDIR}/${FILENAME}.patched ${DIRNAME}/${FILENAME}
if [ "$?" = "1" ]; then exit 3 ; fi

# exit successfully
exit 0

