#!/bin/bash

shift=1
if=""
of="output.txt"

while getopts "s:i:o:" opt; do
    case $opt in 
        "s")
            shift_val=$OPTARG
            ;;
        "i")
            if=$OPTARG
            ;;
        "o")
            of=$OPTARG
            ;;
        \?)
            echo "Invalid argument -$OPTARG provided"
            ;;
        :)
            echo "Option $OPTARG requires an argument"
            ;;
    esac
done


if [ ! -f "$if" ]; then
    echo "Input file not found!"
    exit 1
fi

caesar_cipher() {
    local input_text="$1"
    local shift="$2"
    local output=""

    for ((i = 0; i < ${#input_text}; i++)); do
        char="${input_text:$i:1}"
        if [[ "$char" =~ [A-Za-z] ]]; then
            ascii_val=$(printf "%d" "'$char" 2>/dev/null)
            if [[ "$char" =~ [A-Z] ]]; then
                ascii_val=$((ascii_val - 65))
                ascii_val=$((ascii_val + shift))
                ascii_val=$((ascii_val % 26))
                ascii_val=$((ascii_val + 65))
            else
                ascii_val=$((ascii_val - 97))
                ascii_val=$((ascii_val + shift))
                ascii_val=$((ascii_val % 26))
                ascii_val=$((ascii_val + 97))
            fi
            new_char=$(printf "\\$(printf '%03o' "$ascii_val")")
        fi
        output+="$new_char"
    done

    echo "$output"
}

input_text=$(<"$if")

output_text=$(caesar_cipher "$input_text" "$shift_value")

echo "$output_text" > "$of"
echo "FIN"
