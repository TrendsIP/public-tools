#!/bin/bash

# Check if there are uncommitted changes in the working tree
if ! git diff-index --quiet HEAD --; then
    echo -e "\033[93mWarning: You have uncommitted changes. The tag will only apply to the latest commit.\033[0m"
fi

# Fetch all tags from the remote repository
git fetch --tags

# Get the highest tag number, and add 1
tag=$(git tag | grep -E '^v[0-9]+$' | sort -V | tail -n1 | awk -F 'v' '{print $2}')
new_tag=$((tag+1))

# Create new tag and push it to remote
new_tag="v$new_tag"
echo -e "Ready to tag latest commit with $new_tag, and push both to remote."

read -p "Proceed? (Y/n) " user_input
if [[ "$user_input" == "n" || "$user_input" == "N" ]]; then
    echo "Operation cancelled."
    exit 1
fi

git tag $new_tag
git push origin HEAD $new_tag

echo "Tag $new_tag created and pushed"
