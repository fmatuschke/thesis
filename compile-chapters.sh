#!/bin/bash
set -e

compile-chapter(){
	echo $1
	j=$(echo $1 | tr -dc '0-9')
	if [ -z "$j" ]; then
		j="appendix"
	fi
	grep -vwE "(%gitignore)" thesis.tex > thesis-tikz-$j.tex
	sed -i 's&\% \\includeonly{\%&\\includeonly{'"$i"'}&g' thesis-tikz-$j.tex
	sed -i 's&\\include{content&\%\\include{content&g' thesis-tikz-$j.tex
	sed -i 's&\%\\include{content/'"$j"'&\\include{content/'"$j"'&g' thesis-tikz-$j.tex

	lualatex -interaction=nonstopmode -halt-on-error -shell-escape thesis-tikz-$j.tex &>/dev/null
	echo "$1 done"
}

for i in content/*chap*.tex content/appendix.tex; do
	compile-chapter $i &
done
