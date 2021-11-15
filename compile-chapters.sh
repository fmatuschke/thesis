#!/bin/bash
# set -e

compile-chapter(){
	j=$(echo $1 | tr -dc '0-9')
	if [ -z "$j" ]; then
		j="appendix"
	fi
	grep -vwE "(%gitignore)" thesis.tex > thesis-tikz-$j.tex
	sed -i 's&\% \\includeonly{\%&\\includeonly{'"$1"'}&g' thesis-tikz-$j.tex
	sed -i 's&\\include{content&\%\\include{content&g' thesis-tikz-$j.tex
	sed -i 's&\%\\include{content/'"$j"'&\\include{content/'"$j"'&g' thesis-tikz-$j.tex

	if [ $# -eq 1 ]; then
		lualatex -interaction=nonstopmode -halt-on-error -shell-escape thesis-tikz-$j.tex &>/dev/null
	else
		lualatex -interaction=nonstopmode -halt-on-error -shell-escape thesis-tikz-$j.tex
	fi

	if [ $? -eq 0 ]; then
		rm thesis-tikz-$j*
		echo "$1 done"
	else
		echo -e "\033[0;31m\033[1m$1 error\033[0m"
	fi
}

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
fi

if [ $1 = "all" ]; then
	c=0
	for i in content/*chap*.tex content/appendix.tex; do
		compile-chapter $i &
		pids[${c}]=$!
		let "c+=1" 
	done

	# wait for all pids
	for pid in ${pids[*]}; do
		wait $pid
	done
	echo "All done"
else
	for i in content/${1}*.tex; do
		compile-chapter $i log
	done
fi
