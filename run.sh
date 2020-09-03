#!/bin/bash
set -e

export open=xdf-open
if [ -f "/home/till/.local/bin/wsl-open" ]; then
   export open=wsl-open
fi

if [ "$1" = "--clean" ]; then
   rm -rf output
   rm -rf tikz
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
   exit
fi

# mkdir -p output/tikz/output/tikz
# find . -type d -not -path "./output*" -exec mkdir -p output/{} \;
find gfx -type d -exec mkdir -p tikz/{} \;
find dev -type d -exec mkdir -p tikz/{} \;
# find gfx -type d -exec mkdir -p output/tikz/{} \;
# find dev -type d -exec mkdir -p output/tikz/{} \;
# find gfx -type d -exec mkdir -p output/tikz/output/tikz/{} \;
# find dev -type d -exec mkdir -p output/tikz/output/tikz/{} \;
# cp -r output/tikz output/tikz/output/

if [ "$1" = "--single" ]; then
   lualatex -interaction=nonstopmode -halt-on-error -shell-escape thesis.tex
   eval "$open output/thesis.pdf &> /dev/null 2>&1"
   exit
fi

#find . -type f -exec sed -i.bak '/^%/!s/\([.!?]\) \([[:upper:]]\)/\1\n\2/g' {} \;

lualatex -interaction=nonstopmode -halt-on-error -shell-escape thesis.tex
biber thesis
lualatex -interaction=nonstopmode -halt-on-error -shell-escape thesis.tex

# find output/tikz -type f -iname "*.pdf" -exec echo cp {} /tikz/{} \;
# rsync -avu --filter="- *" --filter="+ *.pdf" output/tikz .

eval "$open thesis.pdf &> /dev/null 2>&1"
