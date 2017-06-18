#!/bin/bash

#code originaly take from https://apple.stackexchange.com/questions/176726/mac-os-x-report-time-on-battery-since-last-ac-unplug-but-exclude-sleep-time
#maintain by xnohat@gmail.com
#update on 18th Jun 2017
#using GetBitBar to put this script to menu bar https://getbitbar.com/

humantime () { printf -v $1 "%dh%02dm%02ds" $(($2/3600)) $((($2/60)%60)) $(($2%60)); }
#unplugged=`pmset -g log | grep 'Summary- \[System: DeclUser.*\] Using Batt' | tail -1 | cut -f1,2 -d' '`
#unplugged=`syslog -u -k Sender loginwindow | grep 'magsafeStateChanged state changed old 1 new 2' | tail -n 1 | cut -f1 -dZ`
unplugged=`log show --style syslog | grep 'magsafeStateChanged state changed old 1 new 2' | tail -n 1 | cut -f1,2 -d" " | cut -f1 -d"."`
onbatt=$((`date +%s` - `date -j -f "%Y-%m-%d %H:%M:%S" "$unplugged" +%s`))
slept=`pmset -g log | sed -n "/^$unplugged/,//p" | awk '/Entering Sleep.*[0-9]+ secs/ {n=split($0,a," ");sum+=a[n-1]} END {print sum}'`
[[ -z $slept ]] && slept=0
awake=$((onbatt-slept))
remain=`pmset -g batt | head -n2 | tail -1 | cut -d' ' -f5`
humantime hawake $awake
humantime hslept $slept
hremain=`date -j -f "%H:%M" "$remain" "+%Hh%Mm"`
printf "Awake on battery for $hawake (%.1f%%)\n" `echo "$awake*100/$onbatt" | bc -l`
printf "Slept on battery for $hslept (%.1f%%)\n" `echo "$slept*100/$onbatt" | bc -l`
printf "Remain on battery for $hremain\n"

