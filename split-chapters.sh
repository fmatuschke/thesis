#!/bin/bash
set -e

while read -r line ; do
   num=$(echo "$line" | grep -o -P '(?<=}{)\d.*(?=}{ch|}{ap)')
   pages+=("$num")
done < <(fgrep chapter\}\{\\nu thesis.toc)

# echo "${pages[@]}"

first=("${pages[@]:0:11}")
last=("${pages[@]:1:12}")

# echo "${first[@]}"
# echo "${last[@]}"
# echo ${!first[@]}
# echo ${!last[@]}

delta=16
dpages=(3 1 1 5 1 1 7 1 5 1 19)

for i in "${!dpages[@]}"; do
   ii=$(printf "%02d" $(($i+1)))
   cbegin=$((${first[i]} + $delta))
   clast=$((${last[i]} + $delta - ${dpages[i]}))
   clast=$((${clast} + (${clast}-${cbegin}+1)%2 )) # chapter ends even
   echo "${ii}: ${cbegin} - ${clast}"
   pdftk thesis.pdf cat ${cbegin}-${clast} output thesis-chapter-${ii}.pdf
done

echo "appendix: $((${pages[11]} + 8 )) - end"
pdftk thesis.pdf cat $((${pages[11]} + 8))-end output thesis-appendix.pdf
