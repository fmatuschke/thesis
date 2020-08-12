#!/bin/bash
set -e

mkdir -p output/tikz/output/tikz
find . -type d -not -path "./output*" -exec mkdir -p output/{} \;

#find . -type f -exec sed -i.bak '/^%/!s/\([.!?]\) \([[:upper:]]\)/\1\n\2/g' {} \;

lualatex -interaction=nonstopmode -halt-on-error -output-directory=output/ --shell-escape thesis.tex
biber --output-directory output output/thesis
lualatex -interaction=nonstopmode -halt-on-error -output-directory=output/ --shell-escape thesis.tex
xdg-open output/thesis.pdf
