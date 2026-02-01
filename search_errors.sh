#!/bin/bash

# Check if filename argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>"
    echo "This script searches for exceptions and errors in a file."
    exit 1
fi

filename="$1"

# Check if file exists
if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' not found."
    exit 1
fi

echo "Searching for exceptions and errors in: $filename"
echo "=============================================="

# Search for common exception and error patterns
if grep -in "exception\|error\|fatal\|critical\|failed\|failure\|invalid\|undefined\|null\|crash" "$filename"; then
    echo "=============================================="
    echo "Search completed. Results shown above."
else
    echo "No exceptions or errors found."
fi
