#!/bin/bash

declare -i F0=0
declare -i F1=1
declare -i n=$1
declare -i res=$n

for ((i=1; i<$n; i++)); do
    res=`expr $F0+$F1`
    F0=$F1
    F1=$res
done

echo $res
