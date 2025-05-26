#!/bin/bash

# Implementation Guide Generator
# Generates a comprehensive implementation guide from git diff between branches
# Enhanced version with file extraction and git repository management
# Designed to be run from outside the target repository

# Configuration
FEATURE_BRANCH="marker-api-content-extraction"
BASE_BRANCH="main"
OUTPUT_FILE="implementation_guide.md"
MANIFEST_FILE="file_manifest.md"
MODIFIED_FILES_DIR="modified_files"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Remote repository configuration
REMOTE_REPO="https://github.com/Hisma/marker_api_feature.git"
DEFAULT_BRANCH="main"

# Repository path - can be passed as first argument or defaults to current directory
REPO_PATH=${1:-"."}

# Override branches if provided as arguments
if [ $# -ge 2 ]; then
    FEATURE_BRANCH="$2"
fi

if [ $# -ge 3 ]; then
    BASE_BRANCH="$3"
fi

# Function to initialize git repository in script directory
init_feature_repo() {
    echo "Initializing feature repository..."
    cd "$SCRIPT_DIR" || exit 1
    
    if [ ! -d ".git" ]; then
        git init
        echo "# Marker API Feature Development Repository" > README.md
        echo "" >> README.md
        echo "This repository tracks all file changes during the development of the marker API feature." >> README.md
        echo "" >> README.md
        echo "## Structure" >> README.md
        echo "- \`modified_files/\` - Contains copies of all modified/added files preserving project structure" >> README.md
        echo "- \`implementation_guide.md\` - Generated implementation guide" >> README.md
        echo "- \`file_manifest.md\` - Manifest of all copied files" >> README.md
        
        # Create .gitignore
        cat > .gitignore << EOF
# Temporary files
*.tmp
*.temp
.DS_Store
Thumbs.db
EOF
        
        git add README.md .gitignore
        git commit -m "Initial commit: Setup marker API feature repository"
        echo "Git repository initialized successfully."
    else
        echo "Git repository already exists."
    fi
    
    # Setup remote repository if configured
    if [ -n "$REMOTE_REPO" ]; then
        if ! git remote get-url origin >/dev/null 2>&1; then
            echo "Adding remote origin: $REMOTE_REPO"
            git remote add origin "$REMOTE_REPO"
        else
            echo "Remote origin already configured."
        fi
        
        # Rename branch to main if needed
        current_branch=$(git branch --show-current)
        if [ "$current_branch" != "$DEFAULT_BRANCH" ]; then
            echo "Renaming branch from $current_branch to $DEFAULT_BRANCH"
            git branch -M "$DEFAULT_BRANCH"
        fi
    fi
}

# Function to get commit hash of feature branch
get_feature_commit() {
    cd "$REPO_PATH" || exit 1
    git rev-parse --short "$FEATURE_BRANCH"
}

# Function to extract file from specific branch
extract_file_from_branch() {
    local branch="$1"
    local file_path="$2"
    local dest_path="$3"
    
    cd "$REPO_PATH" || return 1
    
    # Create destination directory
    mkdir -p "$(dirname "$dest_path")"
    
    # Extract file from branch
    if git show "$branch:$file_path" > "$dest_path" 2>/dev/null; then
        return 0
    else
        echo "Warning: Could not extract $file_path from branch $branch"
        return 1
    fi
}

# Function to copy changed files from feature branch
copy_changed_files() {
    echo "Copying changed files from feature branch..."
    cd "$SCRIPT_DIR" || exit 1
    
    # Create modified_files directory
    mkdir -p "$MODIFIED_FILES_DIR"
    
    # Get list of changed files
    local changed_files
    changed_files=$(cd "$REPO_PATH" && git diff --name-status "$BASE_BRANCH" "$FEATURE_BRANCH")
    
    local copied_files=()
    local failed_files=()
    
    while IFS=$'\t' read -r status file_path; do
        case $status in
            A|M)  # Added or Modified files
                local dest_path="$SCRIPT_DIR/$MODIFIED_FILES_DIR/$file_path"
                echo "  Copying $status: $file_path"
                
                if extract_file_from_branch "$FEATURE_BRANCH" "$file_path" "$dest_path"; then
                    copied_files+=("$status:$file_path")
                else
                    failed_files+=("$status:$file_path")
                fi
                ;;
            D)  # Deleted files - remove from our copy if it exists
                local dest_path="$SCRIPT_DIR/$MODIFIED_FILES_DIR/$file_path"
                if [ -f "$dest_path" ]; then
                    echo "  Removing deleted file: $file_path"
                    rm -f "$dest_path"
                    # Remove empty directories
                    rmdir -p "$(dirname "$dest_path")" 2>/dev/null || true
                fi
                ;;
            R*)  # Renamed files
                echo "  Handling renamed file: $file_path"
                # For renamed files, git shows "old_name -> new_name"
                # We'll treat this as delete old, add new
                ;;
        esac
    done <<< "$changed_files"
    
    echo "File copying completed:"
    echo "  Successfully copied: ${#copied_files[@]} files"
    echo "  Failed to copy: ${#failed_files[@]} files"
    
    # Return arrays for manifest generation
    printf '%s\n' "${copied_files[@]}" > /tmp/copied_files.txt
    printf '%s\n' "${failed_files[@]}" > /tmp/failed_files.txt
}

# Function to generate manifest file
generate_manifest() {
    echo "Generating file manifest..."
    local feature_commit
    feature_commit=$(get_feature_commit)
    
    cd "$SCRIPT_DIR" || exit 1
    
    cat > "$MANIFEST_FILE" << EOF
# File Manifest

**Generated on:** $TIMESTAMP  
**Repository:** \`$(basename "$REPO_PATH")\`  
**Feature Branch:** \`$FEATURE_BRANCH\` (commit: $feature_commit)  
**Base Branch:** \`$BASE_BRANCH\`

## Copied Files

The following files were extracted from the feature branch and copied to \`$MODIFIED_FILES_DIR/\`:

EOF

    if [ -f /tmp/copied_files.txt ] && [ -s /tmp/copied_files.txt ]; then
        while IFS=':' read -r status file_path; do
            local dest_path="$MODIFIED_FILES_DIR/$file_path"
            local file_size=""
            if [ -f "$dest_path" ]; then
                file_size=$(stat -c%s "$dest_path" 2>/dev/null || echo "unknown")
                file_size=" (${file_size} bytes)"
            fi
            
            case $status in
                A) echo "- **Added:** \`$file_path\`$file_size" >> "$MANIFEST_FILE" ;;
                M) echo "- **Modified:** \`$file_path\`$file_size" >> "$MANIFEST_FILE" ;;
                *) echo "- **$status:** \`$file_path\`$file_size" >> "$MANIFEST_FILE" ;;
            esac
        done < /tmp/copied_files.txt
    else
        echo "No files were successfully copied." >> "$MANIFEST_FILE"
    fi
    
    if [ -f /tmp/failed_files.txt ] && [ -s /tmp/failed_files.txt ]; then
        cat >> "$MANIFEST_FILE" << EOF

## Failed Copies

The following files could not be copied:

EOF
        while IFS=':' read -r status file_path; do
            echo "- **$status:** \`$file_path\` (extraction failed)" >> "$MANIFEST_FILE"
        done < /tmp/failed_files.txt
    fi
    
    cat >> "$MANIFEST_FILE" << EOF

## Directory Structure

\`\`\`
$MODIFIED_FILES_DIR/
$(cd "$MODIFIED_FILES_DIR" 2>/dev/null && find . -type f | sort | sed 's/^/  /' || echo "  (no files)")
\`\`\`

---

*Generated by enhanced implementation guide script on $TIMESTAMP*
EOF

    # Cleanup temp files
    rm -f /tmp/copied_files.txt /tmp/failed_files.txt
}

# Function to commit changes to feature repository
commit_changes() {
    echo "Committing changes to feature repository..."
    cd "$SCRIPT_DIR" || exit 1
    
    local feature_commit
    feature_commit=$(get_feature_commit)
    
    # Stage all changes
    git add .
    
    # Check if there are changes to commit
    if git diff --staged --quiet; then
        echo "No changes to commit."
        return 0
    fi
    
    # Create commit message
    local commit_msg="Update from $FEATURE_BRANCH [$feature_commit] - $TIMESTAMP

Files extracted from feature branch and implementation guide updated.

Generated from: git diff $BASE_BRANCH $FEATURE_BRANCH"
    
    # Commit changes
    git commit -m "$commit_msg"
    echo "Changes committed successfully."
    
    # Push to remote if remote exists
    if git remote get-url origin >/dev/null 2>&1; then
        echo "Pushing to remote repository..."
        if git push origin "$DEFAULT_BRANCH" 2>/dev/null; then
            echo "Successfully pushed to remote repository."
        else
            echo "Warning: Failed to push to remote repository. You may need to push manually."
        fi
    else
        echo "No remote repository configured - skipping push."
    fi
    
    # Show recent commits
    echo ""
    echo "Recent commits:"
    git log --oneline -5
}

# Validate repository path
if [ ! -d "$REPO_PATH" ]; then
    echo "Error: Repository path '$REPO_PATH' does not exist."
    echo "Usage: $0 [repository_path] [feature_branch] [base_branch]"
    exit 1
fi

# Check if it's a git repository
if [ ! -d "$REPO_PATH/.git" ]; then
    echo "Error: '$REPO_PATH' is not a git repository."
    echo "Usage: $0 [repository_path] [feature_branch] [base_branch]"
    exit 1
fi

echo "=== Enhanced Implementation Guide Generator ==="
echo "Repository path: $REPO_PATH"
echo "Feature branch: $FEATURE_BRANCH"
echo "Base branch: $BASE_BRANCH"
echo "Output file: $OUTPUT_FILE"
echo "Script directory: $SCRIPT_DIR"
echo ""

# Change to repository directory for git operations
cd "$REPO_PATH" || {
    echo "Error: Cannot change to repository directory '$REPO_PATH'"
    exit 1
}

# Verify branches exist
if ! git rev-parse --verify "$FEATURE_BRANCH" >/dev/null 2>&1; then
    echo "Error: Branch '$FEATURE_BRANCH' does not exist in repository."
    exit 1
fi

if ! git rev-parse --verify "$BASE_BRANCH" >/dev/null 2>&1; then
    echo "Error: Branch '$BASE_BRANCH' does not exist in repository."
    exit 1
fi

# Initialize feature repository
init_feature_repo

# Copy changed files from feature branch
copy_changed_files

# Generate manifest
generate_manifest

# Return to script directory for output file generation
cd "$SCRIPT_DIR" || exit 1

# Create the implementation guide
cat > "$OUTPUT_FILE" << EOF
# Implementation Guide: $(echo "$FEATURE_BRANCH" | sed 's/-/ /g' | sed 's/\b\w/\U&/g')

**Generated on:** $TIMESTAMP  
**Repository:** \`$(basename "$REPO_PATH")\`  
**Feature Branch:** \`$FEATURE_BRANCH\` (commit: $(get_feature_commit))  
**Base Branch:** \`$BASE_BRANCH\`

## Overview

This document contains the complete diff between the \`$FEATURE_BRANCH\` branch and the \`$BASE_BRANCH\` branch, showing all changes made to implement the feature.

All modified and new files have been extracted from the feature branch and copied to the \`$MODIFIED_FILES_DIR/\` directory, preserving the original project structure.

## Summary Statistics

EOF

# Get diff statistics (run from repo directory)
echo "Collecting diff statistics..."
(cd "$REPO_PATH" && git diff --stat "$BASE_BRANCH" "$FEATURE_BRANCH") >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" << EOF

## Files Changed

The following files were modified, added, or deleted:

EOF

# List changed files (run from repo directory)
(cd "$REPO_PATH" && git diff --name-status "$BASE_BRANCH" "$FEATURE_BRANCH") | while read status file; do
    case $status in
        A) echo "- **Added:** \`$file\` → copied to \`$MODIFIED_FILES_DIR/$file\`" >> "$OUTPUT_FILE" ;;
        M) echo "- **Modified:** \`$file\` → copied to \`$MODIFIED_FILES_DIR/$file\`" >> "$OUTPUT_FILE" ;;
        D) echo "- **Deleted:** \`$file\`" >> "$OUTPUT_FILE" ;;
        R*) echo "- **Renamed:** \`$file\`" >> "$OUTPUT_FILE" ;;
        *) echo "- **$status:** \`$file\`" >> "$OUTPUT_FILE" ;;
    esac
done

cat >> "$OUTPUT_FILE" << EOF

## File Manifest

See [\`$MANIFEST_FILE\`](./$MANIFEST_FILE) for detailed information about copied files.

---

## Detailed Changes

The following sections show the complete diff for each file:

\`\`\`diff
EOF

# Add the complete diff (run from repo directory)
echo "Generating detailed diff..."
(cd "$REPO_PATH" && git diff "$BASE_BRANCH" "$FEATURE_BRANCH") >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" << EOF
\`\`\`

---

## Implementation Notes

### How to Use This Guide

1. **Review the Summary Statistics** to understand the scope of changes
2. **Check the Files Changed** section to see which files were affected
3. **Examine copied files** in the \`$MODIFIED_FILES_DIR/\` directory
4. **Use the Detailed Changes** section to see exactly what was modified
5. **Check the File Manifest** for detailed information about copied files

### Git Commands Used

- **Generate this diff:** \`git diff $BASE_BRANCH $FEATURE_BRANCH\`
- **View file list:** \`git diff --name-status $BASE_BRANCH $FEATURE_BRANCH\`
- **View statistics:** \`git diff --stat $BASE_BRANCH $FEATURE_BRANCH\`
- **Extract files:** \`git show $FEATURE_BRANCH:path/to/file\`

### Regenerating This Guide

To regenerate this guide with updated changes, run:
\`\`\`bash
# From the script directory
./generate_implementation_guide.sh /path/to/repository

# With custom branches
./generate_implementation_guide.sh /path/to/repository feature-branch base-branch
\`\`\`

### Usage Examples

\`\`\`bash
# Generate guide for repository in current directory
./generate_implementation_guide.sh .

# Generate guide for specific repository
./generate_implementation_guide.sh /path/to/my-project

# Generate guide with custom branches
./generate_implementation_guide.sh /path/to/my-project my-feature main

# Generate guide for relative path
./generate_implementation_guide.sh ../my-project
\`\`\`

---

*Generated by enhanced implementation guide script on $TIMESTAMP*
EOF

# Commit all changes to the feature repository
commit_changes

echo ""
echo "=== Generation Complete ==="
echo "Implementation guide generated: $OUTPUT_FILE"
echo "File manifest generated: $MANIFEST_FILE"
echo "Modified files copied to: $MODIFIED_FILES_DIR/"
echo ""
echo "To view the guide:"
echo "  cat $OUTPUT_FILE"
echo "  # or open in your preferred markdown viewer"
echo ""
echo "File sizes:"
echo "  Implementation guide: $(wc -l < "$OUTPUT_FILE") lines"
echo "  File manifest: $(wc -l < "$MANIFEST_FILE") lines"
echo "  Modified files: $(find "$MODIFIED_FILES_DIR" -type f 2>/dev/null | wc -l) files"
