#!/bin/bash
#
#	Patch script for japanese-localization
#
SHARELATEXROOT='/var/www/sharelatex/'
TEMPDIR='/tmp'
Patch_file(){
	DEST=${1}
	BEFORE=${2}
	AFTER=${3}
	OPTION=${4}
	grep "${AFTER}" ${DEST} &>/dev/null
	if [ "$?" = "1" ]; then 
		grep "${BEFORE}" ${DEST} &>/dev/null
		if [ "$?" = "1" ]; then return 1 ; fi
		sed -i -e "s/${BEFORE}/${AFTER}/${OPTION}" ${DEST} &>/dev/null
	fi
	return 0
}
Patch_System_repository(){
	if [ "$1" = "unpatch" ] ; then
		echo ""
		printf "\t \t Unpatching will not be done by this program.\\n"
		printf "\t \t In order to remove texlive package, do it by tlmgr manually.\\n"
		printf "\t             %5s  %-30s --- " "" ""
	elif [ "$1" = "patch" ] ; then
		echo ""
		# install texlive and tlmgr
		tlmgr update --self
		if [ "$?" = "1" ]; then return 1; fi
		tlmgr option repository http://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/	
		if [ "$?" = "1" ]; then return 1; fi
		printf "\t             %5s  %-30s --- " "" ""
	fi
	return 0 
}
Patch_System_langCJK(){
	if [ "$1" = "unpatch" ] ; then
		echo ""
		printf "\t \t Unpatching will not be done by this program.\\n"
		printf "\t \t In order to remove texlive package, do it by tlmgr manually.\\n"
		printf "\t             %5s  %-30s --- " "" ""
	elif [ "$1" = "patch" ] ; then
		echo ""	
		# install texlive and tlmgr
		tlmgr update --self
		if [ "$?" = "1" ]; then return 1; fi
		# install collection-langchinese 
		PACKAGE1='collection-langchinese'
		RET1=`tlmgr info ${PACKAGE1} | grep "installed" | sed -e 's/installed:   //'`
		if [ "${RET1}" = "No" ]; then echo "" ; tlmgr install ${PACKAGE1}; fi
		# install collection-langjapanese 
		PACKAGE2='collection-langjapanese'
		RET2=`tlmgr info ${PACKAGE2} | grep "installed" | sed -e 's/installed:   //'`
		if [ "${RET2}" = "No" ]; then echo "" ; tlmgr install ${PACKAGE2}; fi
		# install collection-langkorean 
		PACKAGE3='collection-langkorean'
		RET3=`tlmgr info ${PACKAGE3} | grep "installed" | sed -e 's/installed:   //'`
		if [ "${RET3}" = "No" ]; then echo "" ; tlmgr install ${PACKAGE3}; fi
		# install xetex 
		# dvipdfmx is simbolic-lined to xdvipdfmx which is included in xetex package.
		PACKAGE4='xetex'
		RET4=`tlmgr info ${PACKAGE4} | grep "installed" | sed -e 's/installed:   //'`
		if [ "${RET4}" = "No" ]; then echo "" ; tlmgr install ${PACKAGE4}; fi
		# text alignment
		if [ "${RET1}" = "No" -o "${RET2}" = "No" -o "${RET3}" = "No" -o "${RET4}" = "No" ]; then
			printf "\t             %5s  %-30s --- " "" ""
		fi
	fi
	return 0 
}
Patch_System_kerberos(){
	if [ "$1" = "unpatch" ] ; then
		echo ""
		printf "\t \t Unpatching will not be done by this program.\\n"
		printf "\t \t In order to remove kerberos, do it by apt-get manually.\\n"
		printf "\t             %5s  %-30s --- " "" ""
	elif [ "$1" = "patch" ] ; then
		# install kerberos
		PACKAGE='libkrb5-dev'
		dpkg -l ${PACKAGE} &>/dev/null
		if [ "$?" = "0" ]; then return 0 ; fi
		DEBIAN_FRONTEND=noninteractive apt-get -y install ${PACKAGE} &>/dev/null
		if [ "$?" = "1" ]; then return 1 ; fi
	fi
	return 0 
}
Patch_Clsi_LatexRunner(){
	FILENAME='LatexRunner.coffee'
	DIRNAME="${SHARELATEXROOT}/clsi/app/coffee"
	if [ "$1" = "unpatch" ] ; then
		if [ -e ${DIRNAME}/${FILENAME}.original ]; then
			mv -f ${DIRNAME}/${FILENAME}.original ${DIRNAME}/${FILENAME}
			if [ "$?" = "1" ]; then return 101 ; fi
		else
			printf "\t \t ${DIRNAME}/${FILENAME}.original does not exist.\\n"
			printf "\t             %5s  %-30s --- " "" ""
			return 102
		fi
	elif [ "$1" = "patch" ] ; then
		# backup original file
		if [ ! -e ${DIRNAME}/${FILENAME}.original ]; then
			if [ ! -e ${DIRNAME}/${FILENAME} ]; then touch ${DIRNAME}/${FILENAME}; fi
			cp -f ${DIRNAME}/${FILENAME} ${DIRNAME}/${FILENAME}.original
			if [ "$?" = "1" ]; then return 201 ; fi
		fi
		BEFORE='else if compiler == "xelatex"'
		 AFTER='else if compiler == "platex"'
		OPTION=''
		Patch_file "${DIRNAME}/${FILENAME}" "${BEFORE}" "${AFTER}" "${OPTION}"
		if [ "$?" = "1" ]; then return 1 ; fi
		BEFORE='command = LatexRunner._xelatexCommand mainFile'
		 AFTER='command = LatexRunner._platexCommand mainFile'
		OPTION=''
		Patch_file "${DIRNAME}/${FILENAME}" "${BEFORE}" "${AFTER}" "${OPTION}"
		if [ "$?" = "1" ]; then return 2 ; fi
		BEFORE='_xelatexCommand: (mainFile) ->'
		 AFTER='_platexCommand: (mainFile) ->'
		OPTION=''
		Patch_file "${DIRNAME}/${FILENAME}" "${BEFORE}" "${AFTER}" "${OPTION}"
		if [ "$?" = "1" ]; then return 3 ; fi
		BEFORE='"-xelatex", "-e", "$pdflatex='\''xelatex -synctex=1 -interaction=batchmode %O %S'\''",'
		 AFTER='"-pdfdvi",  "-e", "$latex='\''platex -synctex=1 -interaction=batchmode %O %S'\''",'
		OPTION=''
		Patch_file "${DIRNAME}/${FILENAME}" "${BEFORE}" "${AFTER}" "${OPTION}"
		if [ "$?" = "1" ]; then return 4 ; fi
	fi
	return 0
}
Patch_Clsi_RequestParser(){
	FILENAME='RequestParser.coffee'
	DIRNAME="${SHARELATEXROOT}/clsi/app/coffee"
	if [ "$1" = "unpatch" ] ; then
		if [ -e ${DIRNAME}/${FILENAME}.original ]; then
			mv -f ${DIRNAME}/${FILENAME}.original ${DIRNAME}/${FILENAME}
			if [ "$?" = "1" ]; then return 101 ; fi
		else
			printf "\t \t ${DIRNAME}/${FILENAME}.original does not exist.\\n"
			printf "\t             %5s  %-30s --- " "" ""
			return 102
		fi
	elif [ "$1" = "patch" ] ; then
		# backup original file
		if [ ! -e ${DIRNAME}/${FILENAME}.original ]; then
			if [ ! -e ${DIRNAME}/${FILENAME} ]; then touch ${DIRNAME}/${FILENAME}; fi
			cp -f ${DIRNAME}/${FILENAME} ${DIRNAME}/${FILENAME}.original
			if [ "$?" = "1" ]; then return 201 ; fi
		fi
		BEFORE='VALID_COMPILERS: \["pdflatex", "latex", "xelatex", "lualatex"\]'
		 AFTER='VALID_COMPILERS: \["pdflatex", "latex", "platex", "lualatex"\]'
		OPTION=''
		Patch_file "${DIRNAME}/${FILENAME}" "${BEFORE}" "${AFTER}" "${OPTION}"
		if [ "$?" = "1" ]; then return 1 ; fi
	fi
	return 0
}
Patch_Web_ClsiManager(){
	FILENAME='ClsiManager.coffee'
	DIRNAME="${SHARELATEXROOT}/web/app/coffee/Features/Compile"
	if [ "$1" = "unpatch" ] ; then
		if [ -e ${DIRNAME}/${FILENAME}.original ]; then
			mv -f ${DIRNAME}/${FILENAME}.original ${DIRNAME}/${FILENAME}
			if [ "$?" = "1" ]; then return 101 ; fi
		else
			printf "\t \t ${DIRNAME}/${FILENAME}.original does not exist.\\n"
			printf "\t             %5s  %-30s --- " "" ""
			return 102
		fi
	elif [ "$1" = "patch" ] ; then
		# backup original file
		if [ ! -e ${DIRNAME}/${FILENAME}.original ]; then
			if [ ! -e ${DIRNAME}/${FILENAME} ]; then touch ${DIRNAME}/${FILENAME}; fi
			cp -f ${DIRNAME}/${FILENAME} ${DIRNAME}/${FILENAME}.original
			if [ "$?" = "1" ]; then return 201 ; fi
		fi
		BEFORE='VALID_COMPILERS: \["pdflatex", "latex", "xelatex", "lualatex"\]'
		 AFTER='VALID_COMPILERS: \["pdflatex", "latex", "platex", "lualatex"\]'
		OPTION=''
		Patch_file "${DIRNAME}/${FILENAME}" "${BEFORE}" "${AFTER}" "${OPTION}"
		if [ "$?" = "1" ]; then return 1 ; fi
	fi
	return 0
}
Patch_Web_ProjectOptionsHandler(){
	FILENAME='ProjectOptionsHandler.coffee'
	DIRNAME="${SHARELATEXROOT}/web/app/coffee/Features/Project"
	if [ "$1" = "unpatch" ] ; then
		if [ -e ${DIRNAME}/${FILENAME}.original ]; then
			mv -f ${DIRNAME}/${FILENAME}.original ${DIRNAME}/${FILENAME}
			if [ "$?" = "1" ]; then return 101 ; fi
		else
			printf "\t \t ${DIRNAME}/${FILENAME}.original does not exist.\\n"
			printf "\t             %5s  %-30s --- " "" ""
			return 102
		fi
	elif [ "$1" = "patch" ] ; then
		# backup original file
		if [ ! -e ${DIRNAME}/${FILENAME}.original ]; then
			if [ ! -e ${DIRNAME}/${FILENAME} ]; then touch ${DIRNAME}/${FILENAME}; fi
			cp -f ${DIRNAME}/${FILENAME} ${DIRNAME}/${FILENAME}.original
			if [ "$?" = "1" ]; then return 201 ; fi
		fi
		BEFORE='safeCompilers = \["xelatex", "pdflatex", "latex", "lualatex"\]'
		 AFTER='safeCompilers = \["platex", "pdflatex", "latex", "lualatex"\]'
		OPTION=''
		Patch_file "${DIRNAME}/${FILENAME}" "${BEFORE}" "${AFTER}" "${OPTION}"
		if [ "$?" = "1" ]; then return 1 ; fi
	fi
	return 0	
}

Patch_Web_PDFJS(){
	FILENAME='pdfRenderer.coffee'
	DIRNAME="${SHARELATEXROOT}/web/public/coffee/ide/pdfng/directives"
	if [ "$1" = "unpatch" ] ; then
		if [ -e ${DIRNAME}/${FILENAME}.original ]; then
			mv -f ${DIRNAME}/${FILENAME}.original ${DIRNAME}/${FILENAME}
			if [ "$?" = "1" ]; then return 101 ; fi
		else
			printf "\t \t ${DIRNAME}/${FILENAME}.original does not exist.\\n"
			printf "\t             %5s  %-30s --- " "" ""
			return 102
		fi
	elif [ "$1" = "patch" ] ; then
		# backup original file
		if [ ! -e ${DIRNAME}/${FILENAME}.original ]; then
			if [ ! -e ${DIRNAME}/${FILENAME} ]; then touch ${DIRNAME}/${FILENAME}; fi
			cp -f ${DIRNAME}/${FILENAME} ${DIRNAME}/${FILENAME}.original
			if [ "$?" = "1" ]; then return 201 ; fi
		fi
		BEFORE='window.PDFJS.cMapUrl = '\''.\/bcmaps\/'\'''
		 AFTER='window.PDFJS.cMapUrl = '\''..\/bcmaps\/'\'''
		OPTION=''
		Patch_file "${DIRNAME}/${FILENAME}" "${BEFORE}" "${AFTER}" "${OPTION}"
		if [ "$?" = "1" ]; then return 1 ; fi
	fi
	return 0
}
Patch_Web_project(){
	FILENAME='Project.coffee'
	DIRNAME="${SHARELATEXROOT}/web/app/coffee/models"	
	if [ "$1" = "unpatch" ] ; then
		if [ -e ${DIRNAME}/${FILENAME}.original ]; then
			mv -f ${DIRNAME}/${FILENAME}.original ${DIRNAME}/${FILENAME}
			if [ "$?" = "1" ]; then return 101 ; fi
		else
			printf "\t \t ${DIRNAME}/${FILENAME}.original does not exist.\\n"
			printf "\t             %5s  %-30s --- " "" ""
			return 102
		fi
	elif [ "$1" = "patch" ] ; then
		# backup original file
		if [ ! -e ${DIRNAME}/${FILENAME}.original ]; then
			if [ ! -e ${DIRNAME}/${FILENAME} ]; then touch ${DIRNAME}/${FILENAME}; fi
			cp -f ${DIRNAME}/${FILENAME} ${DIRNAME}/${FILENAME}.original
			if [ "$?" = "1" ]; then return 201 ; fi
		fi
		BEFORE='default:'\''pdflatex'\'''
		 AFTER='default:'\''platex'\'''
		OPTION=''
		Patch_file "${DIRNAME}/${FILENAME}" "${BEFORE}" "${AFTER}" "${OPTION}"
		if [ "$?" = "1" ]; then return 1 ; fi
	fi
	return 0
}
Patch_System_grunt(){
	if [ "$1" = "unpatch" ] ; then
		cd ${SHARELATEXROOT}
		printf "\nrunning grunt install for unpatching...\n"
		grunt install | grep --line-buffered -e "ERR" -e "Finished" -e "Running" -e "Done"
		if [ "$?" = "1" ]; then return 1 ; fi	
		echo ""; printf "\t             %5s  %-30s --- " "" ""
	elif [ "$1" = "patch" ] ; then
		cd ${SHARELATEXROOT}
		printf "\nrunning grunt install for patching...\n"
		grunt install | grep --line-buffered -e "ERR" -e "Finished" -e "Running" -e "Done"
		if [ "$?" = "1" ]; then return 1 ; fi	
		echo ""; printf "\t             %5s  %-30s --- " "" ""
	fi
	return 0 	
}

Patch_Web_idejs(){
	FILENAME='ide.js'
	DIRNAME="${SHARELATEXROOT}/web/public/minjs"
	if [ "$1" = "unpatch" ] ; then
		if [ -e ${DIRNAME}/${FILENAME}.original ]; then
			mv -f ${DIRNAME}/${FILENAME}.original ${DIRNAME}/${FILENAME}
			if [ "$?" = "1" ]; then return 101 ; fi
		else
			printf "\t \t ${DIRNAME}/${FILENAME}.original does not exist.\\n"
			printf "\t             %5s  %-30s --- " "" ""
			return 102
		fi
	elif [ "$1" = "patch" ] ; then
		# backup original file
		if [ ! -e ${DIRNAME}/${FILENAME}.original ]; then
			if [ ! -e ${DIRNAME}/${FILENAME} ]; then touch ${DIRNAME}/${FILENAME}; fi
			cp -f ${DIRNAME}/${FILENAME} ${DIRNAME}/${FILENAME}.original
			if [ "$?" = "1" ]; then return 201 ; fi
		fi
		BEFORE='x01'
		 AFTER='u200b'
		OPTION='g'
		Patch_file "${DIRNAME}/${FILENAME}" "${BEFORE}" "${AFTER}" "${OPTION}"
		if [ "$?" = "1" ]; then return 1 ; fi
		BEFORE='PLACEHOLDER=".."'
		 AFTER='PLACEHOLDER="\\u200b\\u200b"'
		OPTION=''
		Patch_file "${DIRNAME}/${FILENAME}" "${BEFORE}" "${AFTER}" "${OPTION}"
		if [ "$?" = "1" ]; then return 2 ; fi
	fi
	return 0
}

Patch_Web_leftmenu(){
	FILENAME='left-menu.pug'
	DIRNAME="${SHARELATEXROOT}/web/app/views/project/editor"
	if [ "$1" = "unpatch" ] ; then
		if [ -e ${DIRNAME}/${FILENAME}.original ]; then
			mv -f ${DIRNAME}/${FILENAME}.original ${DIRNAME}/${FILENAME}
			if [ "$?" = "1" ]; then return 101 ; fi
		else
			printf "\t \t ${DIRNAME}/${FILENAME}.original does not exist.\\n"
			printf "\t             %5s  %-30s --- " "" ""
			return 102
		fi
	elif [ "$1" = "patch" ] ; then
		# backup original file
		if [ ! -e ${DIRNAME}/${FILENAME}.original ]; then
			if [ ! -e ${DIRNAME}/${FILENAME} ]; then touch ${DIRNAME}/${FILENAME}; fi
			cp -f ${DIRNAME}/${FILENAME} ${DIRNAME}/${FILENAME}.original
			if [ "$?" = "1" ]; then return 201 ; fi
		fi
		BEFORE='option(value='\''xelatex'\'') XeLaTeX'
		 AFTER='option(value='\''platex'\'') pLaTeX'
		OPTION=''
		Patch_file "${DIRNAME}/${FILENAME}" "${BEFORE}" "${AFTER}" "${OPTION}"
		if [ "$?" = "1" ]; then return 1 ; fi
	fi
	return 0
}

Patch_Web_bcmaps(){
	FILENAME='bcmaps'
	DIRNAME="${SHARELATEXROOT}/web/public/js/libs"
	if [ "$1" = "unpatch" ] ; then
		if [ -e ${DIRNAME}/${FILENAME}.original ]; then
			if [ -e ${DIRNAME}/${FILENAME} ]; then rm -rf ${DIRNAME}/${FILENAME}; fi
			mv -f ${DIRNAME}/${FILENAME}.original ${DIRNAME}/${FILENAME}
			if [ "$?" = "1" ]; then return 101 ; fi
		else
			printf "\t \t ${DIRNAME}/${FILENAME}.original does not exist.\\n"
			printf "\t             %5s  %-30s --- " "" ""
			return 102
		fi		
	elif [ "$1" = "patch" ] ; then
		if [ -d "${TEMPDIR}/${FILENAME}" ]; then
			echo ""
			printf "\t \t bcmaps is found. Patching with existing bcmaps...\\n"
		else
			echo ""
			printf "\t \t bcmaps does not exist. Downloading from Git...\\n"
			git clone https://github.com/mozilla/pdf.js/ ${TEMPDIR}/pdfjs 
			if [ "$?" = "1" ]; then return 201 ; fi
			cp -rf ${TEMPDIR}/pdfjs/external/bcmaps ${TEMPDIR}/${FILENAME}
			if [ "$?" = "1" ]; then return 202 ; fi
		fi
		printf "\t             %5s  %-30s --- " "" ""
		if [ ! -e ${DIRNAME}/${FILENAME}.original ]; then
			if [ ! -e ${DIRNAME}/${FILENAME} ]; then mkdir ${DIRNAME}/${FILENAME}; fi
			mv -f ${DIRNAME}/${FILENAME} ${DIRNAME}/${FILENAME}.original
			if [ "$?" = "1" ]; then return 203 ; fi
		fi
		rm -rf ${DIRNAME}/${FILENAME}
		cp -rf ${TEMPDIR}/${FILENAME} ${DIRNAME}
		if [ "$?" = "1" ]; then return 204 ; fi
	fi
	return 0
}
Patch_Tex_texfontsmap(){
	FILENAME='texfonts.map'
	DIRNAME="${SHARELATEXROOT}"
	if [ "$1" = "unpatch" ] ; then
		if [ -e ${DIRNAME}/${FILENAME}.original ]; then
			if [ -e ${DIRNAME}/${FILENAME} ]; then rm -rf ${DIRNAME}/${FILENAME}; fi
			mv -f ${DIRNAME}/${FILENAME}.original ${DIRNAME}/${FILENAME}
			if [ "$?" = "1" ]; then return 101 ; fi
		else
			printf "\t \t ${DIRNAME}/${FILENAME}.original does not exist.\\n"
			printf "\t             %5s  %-30s --- " "" ""
			return 102
		fi		
	elif [ "$1" = "patch" ] ; then
		if [ ! -e "${TEMPDIR}/${FILENAME}" ]; then
			echo -n '' > ${TEMPDIR}/${FILENAME}
			echo "rml  H :0:ipam.ttf" >> ${TEMPDIR}/${FILENAME}
			echo "gbm  H :0:ipag.ttf" >> ${TEMPDIR}/${FILENAME}
			echo "rmlv V :0:ipam.ttf" >> ${TEMPDIR}/${FILENAME}
			echo "gbmv V :0:ipag.ttf" >> ${TEMPDIR}/${FILENAME}
		fi
		if [ ! -e ${DIRNAME}/${FILENAME}.original ]; then
			if [ ! -e ${DIRNAME}/${FILENAME} ]; then touch ${DIRNAME}/${FILENAME}; fi
			cp -f ${DIRNAME}/${FILENAME} ${DIRNAME}/${FILENAME}.original
			if [ "$?" = "1" ]; then return 201 ; fi
		fi
		cp -f ${TEMPDIR}/${FILENAME} ${DIRNAME}/${FILENAME}
		if [ "$?" = "1" ]; then return 202 ; fi
	fi
	return 0	
}
Patch_Tex_latexmk(){
	FILENAME=`which latexmk | xargs readlink -f | xargs basename`
	 DIRNAME=`which latexmk | xargs readlink -f | xargs dirname`
	if [ "$1" = "unpatch" ] ; then
		if [ -e ${DIRNAME}/${FILENAME}.original ]; then
			mv -f ${DIRNAME}/${FILENAME}.original ${DIRNAME}/${FILENAME}
			if [ "$?" = "1" ]; then return 101 ; fi
		else
			printf "\t \t ${DIRNAME}/${FILENAME}.original does not exist.\\n"
			printf "\t             %5s  %-30s --- " "" ""
			return 102
		fi
	elif [ "$1" = "patch" ] ; then
		# backup original file
		if [ ! -e ${DIRNAME}/${FILENAME}.original ]; then
			if [ ! -e ${DIRNAME}/${FILENAME} ]; then touch ${DIRNAME}/${FILENAME}; fi
			cp -f ${DIRNAME}/${FILENAME} ${DIRNAME}/${FILENAME}.original
			if [ "$?" = "1" ]; then return 201 ; fi
		fi
		BEFORE='$latex  = '\''latex %O %S'\'''
		 AFTER='$latex  = '\''platex -shell-escape %O %S'\'''
		OPTION=''
		Patch_file "${DIRNAME}/${FILENAME}" "${BEFORE}" "${AFTER}" "${OPTION}"
		if [ "$?" = "1" ]; then return 1 ; fi
		BEFORE='$bibtex  = '\''bibtex %O %B'\'''
		 AFTER='$bibtex  = '\''pbibtex %O %B'\'''
		OPTION=''
		Patch_file "${DIRNAME}/${FILENAME}" "${BEFORE}" "${AFTER}" "${OPTION}"
		if [ "$?" = "1" ]; then return 2 ; fi
		BEFORE='$dvipdf  = '\''dvipdf %O %S %D'\'''
		 AFTER='$dvipdf  = '\''dvipdfmx -f \/var\/www\/sharelatex\/texfonts.map %O -o %D %S'\'''
		OPTION=''
		Patch_file "${DIRNAME}/${FILENAME}" "${BEFORE}" "${AFTER}" "${OPTION}"
		if [ "$?" = "1" ]; then return 3 ; fi
	fi
	return 0
}
# Main patch function
# Patch_language_japanese(){
	CMD=$1
	SHARELATEXROOT=$2
	SUCSEEDFLAG=0
	# command check
	if [ "$1" != "patch" -a "$1" != "unpatch" ]; then
		exit 1 ;
	fi
	# prompt
	echo "Start ${1}ing japanese-language compilation for sharelatex." 
	if [ ! -d ${TEMPDIR} ]; then mkdir ${TEMPDIR}; fi
	#
	# patch/unpatch execute
	#
	printf "\t Processing  %5s: %-30s --- " "sys" "repository" 	
	# Patch_System_repository ${CMD}
	:	
	RET=$?; if [ "${RET}" = "0" ]; then echo -e "[\033[0;32m OK \033[0;39m]"; else echo -e "[\033[0;31m NG \033[0;39m]:${RET}"; SUCSEEDFLAG=1; fi
	printf "\t Processing  %5s: %-30s --- " "sys" "langCJK" 	
	# Patch_System_langCJK ${CMD}
    :	
	RET=$?; if [ "${RET}" = "0" ]; then echo -e "[\033[0;32m OK \033[0;39m]"; else echo -e "[\033[0;31m NG \033[0;39m]:${RET}"; SUCSEEDFLAG=1; fi
	printf "\t Processing  %5s: %-30s --- " "sys" "kerberos" 	
	Patch_System_kerberos ${CMD}
	RET=$?; if [ "${RET}" = "0" ]; then echo -e "[\033[0;32m OK \033[0;39m]"; else echo -e "[\033[0;31m NG \033[0;39m]:${RET}"; SUCSEEDFLAG=1; fi
	printf "\t Processing  %5s: %-30s --- " "clsi" "LatexRunner.coffee" 	
	Patch_Clsi_LatexRunner ${CMD}
	RET=$?; if [ "${RET}" = "0" ]; then echo -e "[\033[0;32m OK \033[0;39m]"; else echo -e "[\033[0;31m NG \033[0;39m]:${RET}"; SUCSEEDFLAG=1; fi
	printf "\t Processing  %5s: %-30s --- " "clsi" "RequestParser.coffee" 	
	Patch_Clsi_RequestParser ${CMD}
	RET=$?; if [ "${RET}" = "0" ]; then echo -e "[\033[0;32m OK \033[0;39m]"; else echo -e "[\033[0;31m NG \033[0;39m]:${RET}"; SUCSEEDFLAG=1; fi
	printf "\t Processing  %5s: %-30s --- " "web" "ClsiManager.coffee" 	
	Patch_Web_ClsiManager ${CMD}
	RET=$?; if [ "${RET}" = "0" ]; then echo -e "[\033[0;32m OK \033[0;39m]"; else echo -e "[\033[0;31m NG \033[0;39m]:${RET}"; SUCSEEDFLAG=1; fi
	printf "\t Processing  %5s: %-30s --- " "web" "ProjectOptionsHandler.coffeee" 	
	Patch_Web_ProjectOptionsHandler ${CMD}
	RET=$?; if [ "${RET}" = "0" ]; then echo -e "[\033[0;32m OK \033[0;39m]"; else echo -e "[\033[0;31m NG \033[0;39m]:${RET}"; SUCSEEDFLAG=1; fi
	printf "\t Processing  %5s: %-30s --- " "web" "pdfRenderer.coffee"
	Patch_Web_PDFJS ${CMD}
	RET=$?; if [ "${RET}" = "0" ]; then echo -e "[\033[0;32m OK \033[0;39m]"; else echo -e "[\033[0;31m NG \033[0;39m]:${RET}"; SUCSEEDFLAG=1; fi	
	printf "\t Processing  %5s: %-30s --- " "web" "Project.coffee"
	Patch_Web_project ${CMD}
	RET=$?; if [ "${RET}" = "0" ]; then echo -e "[\033[0;32m OK \033[0;39m]"; else echo -e "[\033[0;31m NG \033[0;39m]:${RET}"; SUCSEEDFLAG=1; fi	
	printf "\t Processing  %5s: %-30s --- " "sys" "grunt install"
	# Patch_System_grunt ${CMD}
	:	
	RET=$?; if [ "${RET}" = "0" ]; then echo -e "[\033[0;32m OK \033[0;39m]"; else echo -e "[\033[0;31m NG \033[0;39m]:${RET}"; SUCSEEDFLAG=1; fi	
	printf "\t Processing  %5s: %-30s --- " "web" "ide.js" 	
	Patch_Web_idejs ${CMD}
	RET=$?; if [ "${RET}" = "0" ]; then echo -e "[\033[0;32m OK \033[0;39m]"; else echo -e "[\033[0;31m NG \033[0;39m]:${RET}"; SUCSEEDFLAG=1; fi
	printf "\t Processing  %5s: %-30s --- " "web" "left-menu.pug" 	
	Patch_Web_leftmenu ${CMD}
	RET=$?; if [ "${RET}" = "0" ]; then echo -e "[\033[0;32m OK \033[0;39m]"; else echo -e "[\033[0;31m NG \033[0;39m]:${RET}"; SUCSEEDFLAG=1; fi
	printf "\t Processing  %5s: %-30s --- " "web" "bcmaps"
	Patch_Web_bcmaps ${CMD}
	RET=$?; if [ "${RET}" = "0" ]; then echo -e "[\033[0;32m OK \033[0;39m]"; else echo -e "[\033[0;31m NG \033[0;39m]:${RET}"; SUCSEEDFLAG=1; fi
	printf "\t Processing  %5s: %-30s --- " "latex" "texfonts.map"
	Patch_Tex_texfontsmap ${CMD}
	RET=$?; if [ "${RET}" = "0" ]; then echo -e "[\033[0;32m OK \033[0;39m]"; else echo -e "[\033[0;31m NG \033[0;39m]:${RET}"; SUCSEEDFLAG=1; fi
	printf "\t Processing  %5s  %-30s --- " "latex" "latexmk.pl"
	Patch_Tex_latexmk ${CMD}
	RET=$?; if [ "${RET}" = "0" ]; then echo -e "[\033[0;32m OK \033[0;39m]"; else echo -e "[\033[0;31m NG \033[0;39m]:${RET}"; SUCSEEDFLAG=1; fi
	if [ "${SUCSEEDFLAG}" = "0" ]; then
		echo -e "Succesfully proceed ${1}ing.";
		echo -e "Please restart sharelatex by slmgr manually.";
	else
		echo -e "Failed ${1}ing.";
		exit 1
	fi
	exit 0
# }
