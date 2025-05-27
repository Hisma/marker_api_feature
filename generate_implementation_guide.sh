#!/bin/bash

# Implementation Guide Generator
# Generates a comprehensive implementation guide from git diff between branches
# Enhanced version with merge-base logic so merges/rebases of main are ignored
# Cleans out modified_files/ on each run

set -e

# Configuration
FEATURE_BRANCH="marker-api-content-extraction"
BASE_BRANCH="main"
OUTPUT_FILE="implementation_guide.md"
MANIFEST_FILE="file_manifest.md"
MODIFIED_FILES_DIR="modified_files"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Remote repository configuration (feature‐tracking repo)
REMOTE_REPO="https://github.com/Hisma/marker_api_feature.git"
DEFAULT_BRANCH="main"

# Repository path – can be passed as first argument or defaults to current directory
REPO_PATH=${1:-"."}

# Override branches if provided as arguments
if [ $# -ge 2 ]; then
    FEATURE_BRANCH="$2"
fi
if [ $# -ge 3 ]; then
    BASE_BRANCH="$3"
fi

# Ensure REPO_PATH exists and is a git repo
if [ ! -d "$REPO_PATH" ]; then
    echo "Error: Repository path '$REPO_PATH' does not exist."
    echo "Usage: $0 [repository_path] [feature_branch] [base_branch]"
    exit 1
fi
if [ ! -d "$REPO_PATH/.git" ]; then
    echo "Error: '$REPO_PATH' is not a git repository."
    echo "Usage: $0 [repository_path] [feature_branch] [base_branch]"
    exit 1
fi

echo "=== Enhanced Implementation Guide Generator ==="
echo "Repository path: $REPO_PATH"
echo "Feature branch:   $FEATURE_BRANCH"
echo "Base branch:      $BASE_BRANCH"
echo "Output file:      $OUTPUT_FILE"
echo "Script directory: $SCRIPT_DIR"
echo ""

# Verify branches exist
cd "$REPO_PATH"
git rev-parse --verify "$FEATURE_BRANCH" >/dev/null 2>&1 || { echo "Error: Branch '$FEATURE_BRANCH' not found."; exit 1; }
git rev-parse --verify "$BASE_BRANCH"   >/dev/null 2>&1 || { echo "Error: Branch '$BASE_BRANCH' not found.";   exit 1; }

# Compute the true diff-base: the last common ancestor of base & feature
BASE_COMMIT=$(git merge-base "$BASE_BRANCH" "$FEATURE_BRANCH")
echo "Using merge-base commit $BASE_COMMIT (common ancestor of $BASE_BRANCH & $FEATURE_BRANCH)"
echo ""

# -----------------------------------------------------------------------------
# init_feature_repo: sets up (if needed) a separate git repo in the script dir
# -----------------------------------------------------------------------------
init_feature_repo() {
    echo "Initializing feature repository..."
    cd "$SCRIPT_DIR"
    if [ ! -d ".git" ]; then
        git init
        cat > README.md << EOF
# Marker API Feature Development Repository

This repository tracks all file changes during the development of the marker API feature.

## Structure
- \`modified_files/\` - copies of all modified/added files
- \`implementation_guide.md\` - generated implementation guide
- \`file_manifest.md\` - manifest of all copied files
EOF
        cat > .gitignore << EOF
# Temporary files
*.tmp
*.temp
.DS_Store
Thumbs.db
EOF
        git add README.md .gitignore
        git commit -m "Initial commit: Setup marker API feature repository"
    else
        echo "Git repository already exists."
    fi

    # configure remote if provided
    if [ -n "$REMOTE_REPO" ]; then
        if ! git remote get-url origin >/dev/null 2>&1; then
            git remote add origin "$REMOTE_REPO"
        fi
        current_branch=$(git branch --show-current)
        if [ "$current_branch" != "$DEFAULT_BRANCH" ]; then
            git branch -M "$DEFAULT_BRANCH"
        fi
    fi
}

# -----------------------------------------------------------------------------
# extract_file_from_branch: pulls a single file from the feature branch
# -----------------------------------------------------------------------------
extract_file_from_branch() {
    local branch="$1" file_path="$2" dest_path="$3"
    cd "$REPO_PATH"
    mkdir -p "$(dirname "$dest_path")"
    if git show "$branch:$file_path" > "$dest_path" 2>/dev/null; then
        return 0
    else
        echo "Warning: Could not extract $file_path from $branch"
        return 1
    fi
}

# -----------------------------------------------------------------------------
# copy_changed_files: copies Added/Modified files since merge-base into modified_files/
# -----------------------------------------------------------------------------
copy_changed_files() {
    echo "Cleaning and copying changed files (post‐sync) from feature branch..."
    cd "$SCRIPT_DIR"
    # completely reset the modified_files directory on each run
    rm -rf "$MODIFIED_FILES_DIR"
    mkdir -p "$MODIFIED_FILES_DIR"

    # list status vs BASE_COMMIT
    local changed
    changed=$(cd "$REPO_PATH" && git diff --name-status "$BASE_COMMIT" "$FEATURE_BRANCH")

    local copied=() failed=()
    while IFS=$'\t' read -r status file; do
        case "$status" in
            A|M)
                echo "  - $status $file"
                if extract_file_from_branch "$FEATURE_BRANCH" "$file" "$SCRIPT_DIR/$MODIFIED_FILES_DIR/$file"; then
                    copied+=("$status:$file")
                else
                    failed+=("$status:$file")
                fi
                ;;
            D)
                # removed in feature => delete any copy
                [ -f "$SCRIPT_DIR/$MODIFIED_FILES_DIR/$file" ] && rm -f "$SCRIPT_DIR/$MODIFIED_FILES_DIR/$file"
                ;;
            R*)
                # you can expand rename logic here if needed
                ;;
        esac
    done <<< "$changed"

    printf '%s\n' "${copied[@]}" > /tmp/copied_files.txt
    printf '%s\n' "${failed[@]}"   > /tmp/failed_files.txt

    echo "Copied: ${#copied[@]} files; Failed: ${#failed[@]} files."
}

# -----------------------------------------------------------------------------
# generate_manifest: creates file_manifest.md listing all copied & failed files
# -----------------------------------------------------------------------------
generate_manifest() {
    echo "Generating file manifest..."
    cd "$SCRIPT_DIR"
    cat > "$MANIFEST_FILE" << EOF
# File Manifest

**Generated on:** $TIMESTAMP  
**Repository:** \`$(basename "$REPO_PATH")\`  
**Feature Branch:** \`$FEATURE_BRANCH\`  
**Base Branch:**    \`$BASE_BRANCH\`  
**Merge-Base:**     \`$BASE_COMMIT\`

## Copied Files
EOF

    if [ -s /tmp/copied_files.txt ]; then
        while IFS=':' read -r st fp; do
            local sz=""
            if [ -f "$MODIFIED_FILES_DIR/$fp" ]; then
                sz=" ($(stat -c%s "$MODIFIED_FILES_DIR/$fp") bytes)"
            fi
            echo "- **${st}**: \`$fp\`$sz" >> "$MANIFEST_FILE"
        done < /tmp/copied_files.txt
    else
        echo "No files were copied." >> "$MANIFEST_FILE"
    fi

    if [ -s /tmp/failed_files.txt ]; then
        echo -e "\n## Failed Copies" >> "$MANIFEST_FILE"
        while IFS=':' read -r st fp; do
            echo "- **${st}**: \`$fp\` (failed)" >> "$MANIFEST_FILE"
        done < /tmp/failed_files.txt
    fi

    echo -e "\n## Directory Structure\n" >> "$MANIFEST_FILE"
    echo '```' >> "$MANIFEST_FILE"
    (cd "$MODIFIED_FILES_DIR" && find . -type f | sed 's/^/  /') >> "$MANIFEST_FILE"
    echo '```' >> "$MANIFEST_FILE"

    echo -e "\n*Generated by script on $TIMESTAMP*" >> "$MANIFEST_FILE"

    rm -f /tmp/copied_files.txt /tmp/failed_files.txt
}

# -----------------------------------------------------------------------------
# commit_changes: commits README, manifest, guide & copied files into feature repo
# -----------------------------------------------------------------------------
commit_changes() {
    echo "Committing to feature‐tracking repo..."
    cd "$SCRIPT_DIR"
    git add .
    if git diff --staged --quiet; then
        echo "No changes to commit."
        return
    fi

    local feature_hash
    feature_hash=$(cd "$REPO_PATH" && git rev-parse --short "$FEATURE_BRANCH")

    git commit -m "Update from $FEATURE_BRANCH [$feature_hash] post-merge-base $BASE_COMMIT

Files extracted from feature branch and implementation guide updated.
Diff against merge-base: $BASE_COMMIT"

    if git remote get-url origin >/dev/null 2>&1; then
        git push origin "$DEFAULT_BRANCH" || echo "Push failed; please push manually."
    fi

    echo "Recent commits:"
    git --no-pager log --oneline -5
}

# -----------------------------------------------------------------------------
# Main execution
# -----------------------------------------------------------------------------

# 1) initialize feature repo
init_feature_repo

# 2) copy changed files since merge-base (cleans modified_files/ first)
copy_changed_files

# 3) generate manifest
generate_manifest

# 4) build the implementation guide
cd "$SCRIPT_DIR"
cat > "$OUTPUT_FILE" << EOF
# Implementation Guide: $(echo "$FEATURE_BRANCH" | sed 's/-/ /g' | sed 's/\b\w/\U&/g')

**Generated on:** $TIMESTAMP  
**Repository:** \`$(basename "$REPO_PATH")\`  
**Feature Branch:** \`$FEATURE_BRANCH\`  
**Base Branch:**    \`$BASE_BRANCH\`  
**Merge-Base:**     \`$BASE_COMMIT\`

## Overview

This document shows all changes made on \`$FEATURE_BRANCH\` *since* it last diverged from \`$BASE_BRANCH\`.

## Summary Statistics

EOF

(cd "$REPO_PATH" && git diff --stat "$BASE_COMMIT" "$FEATURE_BRANCH") >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" << EOF

## Files Changed
EOF

(cd "$REPO_PATH" && git diff --name-status "$BASE_COMMIT" "$FEATURE_BRANCH") | \
while read st f; do
    case $st in
        A) echo "- **Added:**    \`$f\` → \`$MODIFIED_FILES_DIR/$f\`" >> "$OUTPUT_FILE";;
        M) echo "- **Modified:** \`$f\` → \`$MODIFIED_FILES_DIR/$f\`" >> "$OUTPUT_FILE";;
        D) echo "- **Deleted:**  \`$f\`"                 >> "$OUTPUT_FILE";;
        *) echo "- **$st:**       \`$f\`"                >> "$OUTPUT_FILE";;
    esac
done

cat >> "$OUTPUT_FILE" << EOF

## Detailed Changes

\`\`\`diff
EOF

(cd "$REPO_PATH" && git diff "$BASE_COMMIT" "$FEATURE_BRANCH") >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" << EOF
\`\`\`

See [\`$MANIFEST_FILE\`](./$MANIFEST_FILE) for file‐by‐file details.

---

*Generated by enhanced implementation guide script on $TIMESTAMP*
EOF

# 5) finally, commit everything to the feature-tracking repo
commit_changes

echo ""
echo "=== Done ==="
echo "Guide:   $OUTPUT_FILE"
echo "Manifest: $MANIFEST_FILE"
echo "Files:   in $MODIFIED_FILES_DIR/"
