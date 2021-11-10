#!/bin/bash
set -e

compile-chapter(){
	echo $1
	j=$(echo $1 | tr -dc '0-9')
	if [ -z "$j" ]; then
		j="appendix"
	fi
	grep -vwE "(%gitignore)" thesis.tex > thesis-chapter-$j.tex
	sed -i 's&\% \\includeonly{\%&\\includeonly{'"$i"'}&g' thesis-chapter-$j.tex
	sed -i 's&\\include{content&\%\\include{content&g' thesis-chapter-$j.tex
	sed -i 's&\%\\include{content/'"$j"'&\\include{content/'"$j"'&g' thesis-chapter-$j.tex

	lualatex -interaction=nonstopmode -halt-on-error -shell-escape thesis-chapter-$j.tex &>/dev/null
	biber thesis-chapter-$j &>/dev/null
	lualatex -interaction=nonstopmode -halt-on-error -shell-escape thesis-chapter-$j.tex &>/dev/null
	lualatex -interaction=nonstopmode -halt-on-error -shell-escape thesis-chapter-$j.tex &>/dev/null

	if [[ $j =~ .[12479] ]]; then 
		pdftk thesis-chapter-$j.pdf cat 7-end output thesis-chapter-$j-.pdf
	elif [[ $j =~ .[3568] ]]; then 
		pdftk thesis-chapter-$j.pdf cat 3-end output thesis-chapter-$j-.pdf
	else
		pdftk thesis-chapter-$j.pdf cat 8-end output thesis-chapter-$j-.pdf
	fi
	mv thesis-chapter-$j-.pdf thesis-chapter-$j.pdf

	echo "$1 done"
}

for i in content/*chap*.tex content/appendix.tex; do
	compile-chapter $i &
done
