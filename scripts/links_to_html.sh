
#!/bin/bash

# Check if a file path is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <path_to_file>"
    exit 1
fi

input_file="$1"

# Process the file and replace the lines
sed -i -E 's/^\!\[\]\(([^)]+)\)/<img src="\1" align="left" size=25% >/' "$input_file"

echo "Processing complete. The original file has been backed up as ${input_file}.bak."

