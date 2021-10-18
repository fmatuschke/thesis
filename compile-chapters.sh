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
	# cp thesis-chapter.pdf thesis-chapter-$j.pdf
}

for i in content/*chap*.tex content/appendix.tex; do
	compile-chapter $i &
done
