#!/bin/bash

usage() {
    echo "Usage: $0 [-v] [-s <A_WORD> <B_WORD>] [-r] [-l] [-u] -i <input_file> -o <output_file>"
    exit 1
}

v_flag=false
s_flag=false
r_flag=false
l_flag=false
u_flag=false
input_file=""
output_file=""

while getopts ":vs:rli:u:o:" opt; do
    case $opt in
        v)
            v_flag=true
            ;;
        s)
            s_flag=true
            a_word=$OPTARG
            shift $((OPTIND -1))
            b_word=$1
            ;;
        r)
            r_flag=true
            ;;
        l)
            l_flag=true
            ;;
        u)
            u_flag=true
            ;;
        i)
            input_file=$OPTARG
            ;;
        o)
            output_file=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

if [ -z "$input_file" ] || [ -z "$output_file" ]; then
    echo "Input and output files are required." >&2
    usage
fi

if [ ! -f "$input_file" ]; then
    echo "Input file '$input_file' not found!" >&2
    exit 1
fi

while IFS= read -r line; do
    if $r_flag; then
        line=$(echo "$line" | rev)
    fi

    if $s_flag; then
        line=$(echo "$line" | sed "s/$a_word/$b_word/g")
    fi

    if $l_flag; then
        line=$(echo "$line" | tr '[:upper:]' '[:lower:]')
    fi

    if $u_flag; then
        line=$(echo "$line" | tr '[:lower:]' '[:upper:]')
    fi

    if $v_flag; then
        line=$(echo "$line" | tr '[:lower:][:upper:]' '[:upper:][:lower:]')
    fi

    echo "$line" >> "$output_file"
done < "$input_file"

echo "Processing complete."

