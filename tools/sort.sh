#!/bin/bash

# Sample input Markdown table file
input_file=$1
sorted_file="sorted_table.md"

# check arguments
if [ $# -ne 1 ]; then
    echo "Usage: $0 <UNSORTED_FILE_NAME>"
    exit 1
fi

# Extract the header and body
header=$(head -n 2 "$input_file")
body=$(tail -n +3 "$input_file")

# Sort the body alphabetically by the first column
sorted_body=$(echo "$body" | sort)

# Combine the header and the sorted body
echo "$header" > "$sorted_file"
echo "$sorted_body" >> "$sorted_file"

# Output the sorted table
cat "$sorted_file"
