#!/bin/bash

# Function to count occurrences of "clickable-group"
count_clickable_group() {
    local directory="$1"
    local count=0

    # Loop over markdown files in the directory
    for file in "$directory"/*.md; do
        if [[ -f "$file" ]]; then
            # Count occurrences of "clickable-group"
            local occurrences=$(grep -o "clickable-group" "$file" | wc -l)
            ((count+=occurrences))
        fi
    done

    echo "$count"
}

# Function to count occurrences of "clickable-group done"
count_clickable_group_done() {
    local directory="$1"
    local count=0

    # Loop over markdown files in the directory
    for file in "$directory"/*.md; do
        if [[ -f "$file" ]]; then
            # Count occurrences of "clickable-group done"
            local occurrences=$(grep -o "clickable-group done" "$file" | wc -l)
            ((count+=occurrences))
        fi
    done

    echo "$count"
}

# Array of directories to process
directories=(
    "roadmaps.sh"
    # Add more directories if needed
)

# Initialize counters
total_clickable_group=0
total_clickable_group_done=0

# Loop over directories
for dir in "${directories[@]}"; do
    # Count "clickable-group" occurrences in the directory
    clickable_group_count=$(count_clickable_group "$dir")
    ((total_clickable_group+=clickable_group_count))

    # Count "clickable-group done" occurrences in the directory
    clickable_group_done_count=$(count_clickable_group_done "$dir")
    ((total_clickable_group_done+=clickable_group_done_count))

    echo "Directory: $dir"
    echo "Clickable Group: $clickable_group_count"
    echo "Clickable Group Done: $clickable_group_done_count"
done

echo "Total Clickable Group: $total_clickable_group"
echo "Total Clickable Group Done: $total_clickable_group_done"

percentage=$((total_clickable_group_done*100/total_clickable_group))
output_file="badge.svg"
rest=$((100-percentage))

# SVG template
svg_template="<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"100\" height=\"20\">
  <linearGradient id=\"a\" x2=\"0\" y2=\"100%\">
    <stop offset=\"0\" stop-color=\"#4CAF50\" stop-opacity=\".1\"/>
    <stop offset=\"1\" stop-opacity=\".1\"/>
  </linearGradient>
  <rect rx=\"3\" width=\"100\" height=\"20\" fill=\"#4CAF50\"/>
  <rect rx=\"3\" x=\"${percentage}\" width=\"${rest}\" height=\"20\" fill=\"#555\"/>
  <rect rx=\"3\" width=\"100\" height=\"20\" fill=\"url(#a)\"/>
  <g fill=\"#fff\" text-anchor=\"middle\" font-family=\"DejaVu Sans,Verdana,Geneva,sans-serif\" font-size=\"11\">
    <text x=\"50\" y=\"15\" fill=\"#010101\" fill-opacity=\".3\">${total_clickable_group_done}/${total_clickable_group}</text>
    <text x=\"50\" y=\"14\">${total_clickable_group_done}/${total_clickable_group}</text>
  </g>
</svg>"

# Generate the badge SVG
echo "$svg_template" > "$output_file"
echo "Badge generated and saved to $output_file"