#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 [-v] [-s <A_WORD> <B_WORD>] [-r] [-l] [-u] -i <input_file> -o <output_file>"
    exit 1
}

# Default values for options
v_flag=false
s_flag=false
r_flag=false
l_flag=false
u_flag=false
input_file=""
output_file=""

# Parse options
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

# Check if input and output files are provided
if [ -z "$input_file" ] || [ -z "$output_file" ]; then
    echo "Input and output files are required." >&2
    usage
fi

# Check if input file exists
if [ ! -f "$input_file" ]; then
    echo "Input file '$input_file' not found!" >&2
    exit 1
fi

# Process input file
while IFS= read -r line; do
    # Reverse text lines if -r flag is passed
    if $r_flag; then
        line=$(echo "$line" | rev)
    fi

    # Substitute <A_WORD> with <B_WORD> if -s flag is passed
    if $s_flag; then
        line=$(echo "$line" | sed "s/$a_word/$b_word/g")
    fi

    # Convert text to lowercase if -l flag is passed
    if $l_flag; then
        line=$(echo "$line" | tr '[:upper:]' '[:lower:]')
    fi

    # Convert text to uppercase if -u flag is passed
    if $u_flag; then
        line=$(echo "$line" | tr '[:lower:]' '[:upper:]')
    fi

    # Swap lowercase and uppercase if -v flag is passed
    if $v_flag; then
        line=$(echo "$line" | tr '[:lower:][:upper:]' '[:upper:][:lower:]')
    fi

    echo "$line" >> "$output_file"
done < "$input_file"

echo "Processing complete."

