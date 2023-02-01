#!/bin/bash
#From http://brakertech.com/linux-find-large-files/
# find large files
echo "find files over 100MB"
find / -type f -size +100000k -exec ls -lh {} \;
