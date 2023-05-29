#!/bin/bash

# Specify the root directory for search and the target file
ROOT_DIR="gen-types"
TARGET_FILE="gpt-context.txt"

# Clear the target file
> "$TARGET_FILE"

# Add file structures
echo "\n## File structures\n" >> "$TARGET_FILE"
exa --tree --level 3 --git-ignore >> "$TARGET_FILE"

# Add package.json content
echo "\n## package.json\n" >> "$TARGET_FILE"
cat package.json >> "$TARGET_FILE"

# Generate TypeScript definitions
npx tsc --project tsconfig.gen.json

# Add TypeScript definitions
echo "\n## TypeScript definitions\n" >> "$TARGET_FILE"

# Traverse all files under the root directory and its subdirectories
find "$ROOT_DIR" -type f -print0 | while IFS= read -r -d '' file; do
    # Replace the root directory path in the file path with an empty string
    file_rel_path=$(echo "$file" | sed "s|^$ROOT_DIR||")
    # Add file relative path mark before each file content
    echo "// $file_rel_path" >> "$TARGET_FILE"
    # Add the file content to the target file
    cat "$file" >> "$TARGET_FILE"
done

echo "\n\n===\n\nPlease write code with the above project context:\n" >> "$TARGET_FILE"
