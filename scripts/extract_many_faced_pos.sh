#!/bin/bash
files="/home/yusuke/Keyaki/treebank/*psd"
squote="'"
export squote
argv="$1"
export argv
#<< COMMENTOUT
rest=' < (__ !< __) !< /ICH/'
rest2=' !>'
pos="${squote}$1${rest}${squote}"
export pos
export rest2
for filepath in $files; do
    if [ -f $filepath ] ; then
    echo processing $filepath
    eval tregex "$pos" -o -s $filepath | sort | uniq | sort | sed -E "s/^\(${argv}\s(.+)\)$/\1/g" >> ~/Desktop/${argv}s_extracted.txt
    fi
done
#COMMENTOUT

#cat $files > ~/Desktop/all_Keyaki_trees.psd
echo "Concat done"
cat ~/Desktop/${argv}s_extracted.txt | sort | uniq | sponge ~/Desktop/${argv}s_extracted.txt

<< COMMENTOUT
cat ~/Desktop/Qs_extracted.psd | while read line
do
    echo $line
    pattern1="'${line} "
    pattern2='!> /^Q/ '
    pattern3="'"
    pattern=$pattern1$pattern2$pattern3
    eval tregex ${pattern} -s -w ${var} >> ~/Desktop/janus-faced_Qs.psd 
done

COMMENTOUT

function exec_hoge(){
#    local line="$@" 
    local pattern=$squote"$@ "$rest2$argv$squote
    echo $@
    echo $pattern 
    eval tregex "$pattern" -t -o /home/yusuke/Desktop/all_Keyaki_trees.psd  >> ~/Desktop/many-faced_${argv}s.txt 
}

export -f exec_hoge;
cat ~/Desktop/${argv}s_extracted.txt | xargs -I% -P 4 bash -c 'exec_hoge %'
cat ~/Desktop/many-faced_${argv}s.txt | sort | uniq | while read line;
do perl -pe 's/^(.+)\/(.+)$/\1 > \2/m'; done | sponge ~/Desktop/many-faced_${argv}s.txt