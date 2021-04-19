#!/bin/bash
set -e -o pipefail

open=xdg-open
if [ -f "/home/till/.local/bin/wsl-open" ]; then
   open=wsl-open
fi

clean_build() {
   rm -f thesis_.tex
   find . -type f -iname "*.acr" -exec rm {} \;
   find . -type f -iname "*.aux*" -exec rm {} \;
   find . -type f -iname "*.bbl" -exec rm {} \;
   find . -type f -iname "*.bcf" -exec rm {} \;
   find . -type f -iname "*.blg" -exec rm {} \;
   find . -type f -iname "*.dpth" -exec rm {} \;
   find . -type f -iname "*.figlist" -exec rm {} \;
   find . -type f -iname "*.log" -exec rm {} \;
   find . -type f -iname "*.maf" -exec rm {} \;
   find . -type f -iname "*.makefile" -exec rm {} \;
   find . -type f -iname "*.md5" -exec rm {} \;
   find . -type f -iname "*.mtc" -exec rm {} \;
   find . -type f -iname "*.mtc0" -exec rm {} \;
   find . -type f -iname "*.out" -exec rm {} \;
   find . -type f -iname "*.ptc*" -exec rm {} \;
   find . -type f -iname "*.tdo" -exec rm {} \;
   find . -type f -iname "*.toc" -exec rm {} \;
   find . -type f -iname "*.run.xml" -exec rm {} \;
   find . -type f -iname "*:Zone.Identifier" -exec rm {} \;
   rm -f thesis.pdf
}

clean_tikz() {
   rm -rf output
   rm -rf tikz
   mkdir -p tikz
   touch tikz/dummy.tex
}

mv_tikz() {
   mkdir -p tikz
   rm -rf tikz/*/
   for file in tikz/*.log; do
      # echo $file
      tikz=$(grep -e "\.tikz" -e "\.dpth" $file | grep -B 1 "tikz\/.*\.dpth" | tr ' ' '\n' | grep -o "(\.\/gfx.*\.tikz")
      file_in="${file/log/pdf}"
      file_out="${tikz/tikz/pdf}"
      file_out="${file_out/(\.\//}"
      echo $file_in tikz/$file_out
      mkdir -p $(dirname tikz/$file_out)
      if [ -f tikz/$file_out ]; then
         echo tikz/$file_out EXISTS
         exit 1
      fi
      cp $file_in tikz/$file_out
   done
}

underscore_copy() {

   if [ -z "$1" ]; then
      echo "No arguments supplied"
      exit 1
   fi

   FILE=$(basename "$1")
   BASEDIR=$(dirname "$1")
   UNDERSCORE_DIR=$(echo "$BASEDIR" | cut -d "/" -f1)

   # if [[ ! "$FILE" == *"."* ]]; then
   #    FILE="${FILE}.tikz"
   # fi

   if [ $BASEDIR != $UNDERSCORE_DIR ]; then
      REMAINING_DIR=$(echo "$BASEDIR" | cut -d "/" -f2-)
      DIR_DELIMITER='/'
   fi

   # echo "1: $1"
   # echo "FILE: $FILE"
   # echo "BASEDIR: $BASEDIR"
   # echo "UNDERSCORE_DIR: $UNDERSCORE_DIR"
   # echo "DIR_DELIMITER: $DIR_DELIMITER"
   # echo "REMAINING_DIR: $REMAINING_DIR"

   if [ ! -f "${UNDERSCORE_DIR}_$DIR_DELIMITER${REMAINING_DIR}/${FILE}" ]; then
      echo "'${UNDERSCORE_DIR}_$DIR_DELIMITER${REMAINING_DIR}/${FILE}' does not exists"
      exit 1
   fi

   mkdir -p $BASEDIR
   cp ${UNDERSCORE_DIR}_$DIR_DELIMITER${REMAINING_DIR}/${FILE} $1
}

if [ "$1" = "--clean" ]; then
   clean_build
   clean_tikz
   exit 0
fi

if [ "$1" == "--tikz" ]; then
   mv_tikz
   exit 0
fi

if [ "$1" == "--underscore" ]; then
   underscore_copy $2
   exit 0
fi

if [ ! -f tikz/dummy.tex ]; then
   mkdir -p tikz
   touch tikz/dummy.tex
fi

# activate list and make
cp thesis.tex thesis_.tex
sed -i 's/% *mode=list/ mode=list/' thesis_.tex

# first build
lualatex -interaction=nonstopmode -halt-on-error -shell-escape thesis_.tex
#  | tr -d '\n'
# | awk -F'File|not found' '{print $2}'
if [ "$1" = "--single" ]; then
   mv thesis_.pdf thesis.pdf
   eval "$open thesis.pdf &> /dev/null 2>&1"
   exit 0
fi

# second build with tikz make
if [ -f "thesis_.makefile" ]; then
   make -j4 -f thesis_.makefile
fi
biber thesis_
lualatex -interaction=nonstopmode -halt-on-error -shell-escape thesis_.tex

# view
mv thesis_.pdf thesis.pdf
eval "$open thesis.pdf &> /dev/null 2>&1"
