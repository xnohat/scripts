#!/bin/bash 

#SUM_OF_CPU_USAGE=$( ps -C $1 -o pcpu= | awk '{s+=$1} END {print s}' )
#PROC_NAMES=$( ps -eo comm | sort | uniq )
printf "%-18s %-7s\n" "Process Name" "%CPU (Main Proc+Childs)"
ps -eo comm | sort | uniq | while read proc_name ; do
    
    SUM_OF_CPU_USAGE=$(ps -C $proc_name -o pcpu= | awk '{s+=$1} END {print s}')
    re='^[+-]?[0-9]+([.][0-9]+)?$'
    if [[ $SUM_OF_CPU_USAGE =~ $re ]] #check it's number
    then
        printf "%-18s %-7.1f\n" $proc_name $SUM_OF_CPU_USAGE
    fi
done