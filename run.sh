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
   echo "Dont forget to disable 'inputtikz[true]'"

   mkdir -p tikz
   rm -rf tikz/*/
   for file_in in tikz/*.pdf; do
      # echo $file_in
      file=${file_in%.pdf}

      if [ $(grep ${file}.dpth ${file}.log | wc -l) != 1 ]; then
         echo ".dpth not 1 time"
         exit 1
      fi

      line=$(grep -n ${file}.dpth ${file}.log | cut -d : -f 1)

      # name=$(head -n $line $file.log | tac | grep -m 1 -o 'gfx.*\.tikz') WHY DOES THIS NOT WORK ?????
      name=$(head -n $line $file.log | tac | grep -o '(\..*\.tikz')
      name=$(echo "$name" | head -n 1)
      name=$(echo $name | rev | cut -d "(" -f1 | rev)
      name="${name:2}"

      file_out=${name%.tikz}.pdf

      # echo "TEST"
      if [ -f tikz/$file_out ]; then
         echo "$file_in" "tikz/$file_out" EXISTS
         continue
         # exit 1
      fi

      echo "$file_in" "tikz/$file_out"

      mkdir -p $(dirname tikz/$file_out)
      cp $file_in tikz/$file_out
      # echo ""
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
