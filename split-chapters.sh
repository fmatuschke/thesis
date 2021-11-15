#!/bin/bash
set -e

# pages=()
while read -r line ; do
   values=$(echo "$line" | egrep -o '\{[0-9]*\}' )
   num1=$(echo "$values" | cut -f1 -d$'\n' | sed 's/[^0-9]*//g')
   num2=$(echo "$values" | cut -f2 -d$'\n' | sed 's/[^0-9]*//g')
   pages+=("$num2")
done < <(fgrep chapter\}\{\\nu thesis.toc)

# echo "${pages[@]}"
# echo $((${!pages[@]}))

first=("${pages[@]:0:10}")
last=("${pages[@]:1:11}")

# echo "${first[@]}"
# echo "${last[@]}"
# echo ${!first[@]}
# echo ${!last[@]}

delta=12
dpages=( 5 2 7 2 1 6 2 5 2 15)

for i in "${!dpages[@]}"; do
   ii=$(printf "%02d" $(($i+1)))

   # echo "$ii: ${first[i]} - ${last[i]}: $((${first[i]} + $delta)) - $((${last[i]} + $delta - ${dpages[i]}))"
   echo "${ii}: $((${first[i]} + $delta)) - $((${last[i]} + $delta - ${dpages[i]}))"
   pdftk thesis.pdf cat $((${first[i]} + $delta))-$((${last[i]} + $delta - ${dpages[i]})) output thesis-chapter-${ii}.pdf
done

echo "appendix: $((${pages[10]} + 8 )) - end"
pdftk thesis.pdf cat $((${pages[10]} + 8))-end output thesis-appendix.pdf
