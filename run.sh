#!/bin/bash
set -e

export open=xdg-open
if [ -f "/home/till/.local/bin/wsl-open" ]; then
   export open=wsl-open
fi

if [ "$1" = "--clean" ]; then
   rm -rf output
   rm -rf tikz
	rm -f thesis_.tex
   mkdir tikz
   touch tikz/dummy.tex
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
   mkdir -p tikz
   touch tikz/dummy.tex
   exit 0
fi

sed 's/% *mode=list/ mode=list/' thesis.tex > thesis_.tex

if [ "$1" == "--tikz" ]; then
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
   exit 0
fi

if [ ! -f tikz/dummy.tex ]; then
   mkdir -p tikz
   touch tikz/dummy.tex
fi

# mkdir -p output/tikz/output/tikz
# find . -type d -not -path "./output*" -exec mkdir -p output/{} \;
# find gfx -type d -exec mkdir -p tikz/{} \;
# find dev -type d -exec mkdir -p tikz/{} \;
# find gfx -type d -exec mkdir -p output/tikz/{} \;
# find dev -type d -exec mkdir -p output/tikz/{} \;
# find gfx -type d -exec mkdir -p output/tikz/output/tikz/{} \;
# find dev -type d -exec mkdir -p output/tikz/output/tikz/{} \;
# cp -r output/tikz output/tikz/output/

if [ "$1" = "--single" ]; then
   lualatex -interaction=nonstopmode -halt-on-error -shell-escape thesis_.tex
   mv thesis_.pdf thesis.pdf
   eval "$open thesis.pdf &> /dev/null 2>&1"
   exit 0
fi

#find . -type f -exec sed -i.bak '/^%/!s/\([.!?]\) \([[:upper:]]\)/\1\n\2/g' {} \;

lualatex -interaction=nonstopmode -halt-on-error -shell-escape thesis_.tex
if [ -f "thesis_.makefile" ]; then
   make -j4 -f thesis_.makefile
fi
biber thesis_
lualatex -interaction=nonstopmode -halt-on-error -shell-escape thesis_.tex

# find output/tikz -type f -iname "*.pdf" -exec echo cp {} /tikz/{} \;
# rsync -avu --filter="- *" --filter="+ *.pdf" output/tikz .

mv thesis_.pdf thesis.pdf
eval "$open thesis.pdf &> /dev/null 2>&1"
