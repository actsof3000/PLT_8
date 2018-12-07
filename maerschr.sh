#!/bin/bash
#Riley Maersch

for zip in *.ZIP; do
s=${zip%.*}
`mkdir $s`
`unzip $zip -d $s`
done


for pl in submissions/*.pl; do
  base=$(basename $pl)
  s=${base%.*}
  total=$((0))
  passed=$((0))
  cheat=false
  for fn in sampleInput/*.txt; do
    total=$((total+1))
    `swipl $pl $(cat $fn) > test.txt`
    diff=`diff ./test.txt expectedOutput/$(basename $fn).out --ignore-space-change --ignore-case --ignore-blank-lines`
    [ ! -z "$diff" ] && passed=$((passed+1))
    grep=`grep "$(cat $fn)" $pl`
    [ ! -z "$grep" ] && cheat=true
    rm ./test.txt
  done
  percent=$((passed*100/total))
  grade="$s, $percent"
  if $cheat; then
    grade=$grade*
  fi
  `echo $grade >> grades.txt`
done