#!/bin/bash

# Function to determine if a file is binary
is_binary() {
    # Check if the file is binary (using a simple heuristic)
    if [[ $(file -b --mime-encoding "$1") == "binary" ]]; then
        return 0  # Binary file
    else
        return 1  # Not a binary file
    fi
}

# Function to recursively list files and folders
list_files() {
    for file in "$1"/*; do
        if [[ -d "$file" ]]; then
            echo "Folder: $file"
            list_files "$file"  # Recursively list contents of subfolders
        elif [[ -f "$file" ]]; then
            echo "File: $file"
            if ! is_binary "$file"; then
                echo "Content:"
                cat "$file"  # Display file content for non-binary files
            else
                echo "(Binary file, skipping content display)"
            fi
            echo
            echo "========================================================="
            echo
        fi
    done
}

# Start listing from the current directory
list_files "$(pwd)"
