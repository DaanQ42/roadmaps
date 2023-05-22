#!/bin/bash

# Array of directories to process
directories=(
    "roadmaps.sh"
    # Add more directories if needed
)

# Function convert percentage to color
function percentage_to_color() {
    percentage=$1
    if [[ $percentage -gt 80 ]]; then
        echo "green"
    elif [[ $percentage -gt 50 ]]; then
        echo "orange"
    elif [[ $percentage -gt 25 ]]; then
        echo "yellow"
    else
        echo "red"
    fi
}

# Initialize counters
total_clickable_group=0
total_clickable_group_done=0

# Create or clear the status.md file
echo -n "# Status" > status.md
echo "" >> status.md

# Loop over directories
for dir in "${directories[@]}"; do
    # Initialize per-file counters
    clickable_group_per_file=0
    clickable_group_done_per_file=0

    # Count "clickable-group" and "clickable-group done" occurrences per file in the directory
    for file in "$dir"/*.md; do
        if [[ -f "$file" ]]; then
            clickable_group_count=$(grep -o "clickable-group" "$file" | wc -l)
            clickable_group_done_count=$(grep -o "clickable-group done" "$file" | wc -l)

            clickable_group_per_file=$((clickable_group_per_file + clickable_group_count))
            clickable_group_done_per_file=$((clickable_group_done_per_file + clickable_group_done_count))

            # Only do this if there are clickable-group occurrences
            if [[ $clickable_group_count -eq 0 ]]; then
                continue
            fi

            # Get the percentage of "clickable-group done" occurrences
            clickable_group_done_percentage=$((clickable_group_done_count * 100 / clickable_group_count))
            echo "$file: $clickable_group_done_percentage%"
            # color
            clickable_group_done_color=$(percentage_to_color "$clickable_group_done_percentage")

            # Append results to the status.md file
            file_encoded=$(echo "$file" | sed 's/ /%20/g; s/-/_/g')
            echo "- ![$file](https://img.shields.io/badge/$file_encoded-$clickable_group_done_count%2F$clickable_group_count-$clickable_group_done_color)" >> status.md
        fi
    done

    # Update total counters
    ((total_clickable_group += clickable_group_per_file))
    ((total_clickable_group_done += clickable_group_done_per_file))

    echo "Directory: $dir"
    echo "Clickable Group: $clickable_group_per_file/$total_clickable_group"
    echo "Clickable Group Done: $clickable_group_done_per_file/$total_clickable_group_done"
done

echo "Total Clickable Group: $total_clickable_group/$total_clickable_group"
echo "Total Clickable Group Done: $total_clickable_group_done/$total_clickable_group_done"

echo "done=$total_clickable_group_done" >> "$GITHUB_OUTPUT"
echo "total=$total_clickable_group" >> "$GITHUB_OUTPUT"