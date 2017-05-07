#!/bin/bash
#
#	Patch script for japanese-localization
#
SHARELATEXROOT='/var/www/sharelatex'
SLROOTDIR="`pwd`"

patch_dir=()
patch_dir+=("system-texlive_repository")
patch_dir+=("system-texlive_langCJK")
patch_dir+=("system-kerberos")
patch_dir+=("clsi-LatexRunner_coffee")
patch_dir+=("clsi-RequestParser_coffee")
patch_dir+=("web-ProjectOptionsHandler_coffee")
patch_dir+=("web-Project_coffee")
patch_dir+=("web-ClsiManager_coffee")
patch_dir+=("web-pdfRenderer_coffee")
patch_dir+=("system-grunt_install")
patch_dir+=("web-left-menu_pug")
patch_dir+=("web-ide_js")
#patch_dir+=("web-bcmaps")
#patch_dir+=("latex-texfonts_map")
patch_dir+=("latex-latexmk_pl")

# command check
CMD=$1
if [ "${CMD}" != "patch" -a "${CMD}" != "unpatch" ]; then
  echo "Option [patch|unpatch] required."
  exit 1 ;
fi

# tempdir creation
# if [ ! -d ${TEMPDIR} ]; then mkdir ${TEMPDIR}; fi

# patch procedure
SUCSEEDFLAG=0
echo "  ---> ${CMD} started."
for patch in ${patch_dir[@]}; do
  printf "   ---> Processing  %50s : start \\n" ${patch}
  #echo "${SLROOTDIR}/CJK-localization/${patch}/patch.sh"
  ${SLROOTDIR}/CJK-localization/${patch}/${CMD}.sh ${SLROOTDIR}/CJK-localization/${patch} ${SHARELATEXROOT}
  RET=$?
  printf "   ---> Processing  %50s : " ${patch}
  if [ "${RET}" = "0" ]; then echo -e "[\033[0;32m OK \033[0;39m]"; else echo -e "[\033[0;31m NG \033[0;39m]:${RET}"; SUCSEEDFLAG=1; fi
done

if [ "${SUCSEEDFLAG}" != "0" ]; then
  echo "  ---> ${CMD}ing failed."
  exit 1
fi

echo "  ---> Processing  with ${CMD}ing finished successfully."
echo "  ---> Restart sharelatex container is required."
exit 0

