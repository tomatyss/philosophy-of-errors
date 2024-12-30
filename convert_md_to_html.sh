#!/bin/bash

# Directory containing markdown files
INPUT_DIR="src"
# Directory to output HTML files
OUTPUT_DIR="docs"
# Path to the HTML template
TEMPLATE_FILE="template.html"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Read the template file
TEMPLATE=$(<"$TEMPLATE_FILE")

# Loop through all markdown files in the input directory
for md_file in "$INPUT_DIR"/*.md; do
    # Get the base name of the file (without extension)
    base_name=$(basename "$md_file" .md)
    # Extract the first h1 title from the markdown file
    TITLE=$(grep -m 1 '^# ' "$md_file" | sed 's/^# //')
    # Convert markdown file to HTML
    HTML_CONTENT=$(pandoc "$md_file")
    # Replace wiki-style links with HTML links
    HTML_CONTENT=$(echo "$HTML_CONTENT" | sed -E 's/\[\[([^\]]+)\]\]/<a href="\1.html">\1<\/a>/g')
    # Replace placeholders in the template
    FINAL_HTML="${TEMPLATE//\{\{title\}\}/$TITLE}"
    FINAL_HTML="${FINAL_HTML//\{\{content\}\}/$HTML_CONTENT}"
    # Write the final HTML to the output directory
    echo "$FINAL_HTML" > "$OUTPUT_DIR/$base_name.html"
done

echo "Conversion complete. HTML files are in the '$OUTPUT_DIR' directory."