#!/bin/bash
#iterating over the aws profiles

echo "Enter AWS profiles followed by space: "
read test

for value in $test
do
    echo $value
done |
while read -r profile; do
    echo "# ============================================================================ #" >&2
    echo "# AWS profile = $profile" >&2
    echo "# ============================================================================ #" >&2
    export AWS_PROFILE="$profile"
    cmd="aws iam list-users"
    cmd="${cmd//\{profile\}/$profile}"
    eval "$cmd"
    echo >&2
done
