#!/bin/bash

declare -i RES=1000
declare -i NUM=1000
declare -i NUMS

touch temp.txt
INFO="temp.txt"

while getopts "o:n:d" opt; do
    case $opt in
        o)
            case $OPTARG in 
                "+"|"-"|"*"|"/")
                    OP=$OPTARG
                    ;;
                *)
                    echo "Incorrect Operation"
                    ;;
            esac
            ;;
        n)
            NUMS+=("$OPTARG")
            ;;
        d)
            echo "USER: `whoami`" >> $INFO
            echo "SCRIPT: $0" >> $INFO
            echo "OPERATION: $OP" >> $INFO
            echo "NUMBERS: ${NUMS[*]}" >> $INFO
            ;;
    esac
done

case $OP in
    "+"|"-")
        RES=0
        ;;
    "*"|"/")
        RES=1
        ;;
    *)
        RES=500
        ;;
esac

echo ${NUMS[@]}
echo 

for NUM in "${NUMS[@]}"; do
    echo $NUM
    case $OP in
        "+")
            let "RES+=NUM"
            ;;
        "-")
            let "RES-=NUM"
            ;;
        "/")
            let "RES/=NUM"
            ;;
        "*")
            let "RES*=NUM"
            ;;
    esac 
done

echo "RESULT: $RES"
if [ -f $INFO ]; then
    cat $INFO
fi

rm temp.txt
