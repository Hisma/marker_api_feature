#!/bin/bash

# Implementation Guide Generator
# — ignores merges from main by diffing against the true merge-base on origin
# — cleans modified_files/ on each run

set -e

# ───────────────────────────────────────────────────────────────────────────────
# Configuration
# ───────────────────────────────────────────────────────────────────────────────
FEATURE_BRANCH="marker-api-content-extraction"
BASE_BRANCH="main"
OUTPUT_FILE="implementation_guide.md"
MANIFEST_FILE="file_manifest.md"
MODIFIED_FILES_DIR="modified_files"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

REMOTE_REPO="https://github.com/Hisma/marker_api_feature.git"
DEFAULT_BRANCH="main"

# Repo path (arg1) or “.”
REPO_PATH=${1:-"."}

# override branches
if [ $# -ge 2 ]; then FEATURE_BRANCH="$2"; fi
if [ $# -ge 3 ]; then BASE_BRANCH="$3";   fi

# ───────────────────────────────────────────────────────────────────────────────
# sanity checks
# ───────────────────────────────────────────────────────────────────────────────
if [ ! -d "$REPO_PATH" ]; then
  echo "Error: '$REPO_PATH' not found"; exit 1
fi
if [ ! -d "$REPO_PATH/.git" ]; then
  echo "Error: '$REPO_PATH' is not a git repo"; exit 1
fi

echo "=== Implementation Guide Generator ==="
echo "Repo path:   $REPO_PATH"
echo "Feature:     $FEATURE_BRANCH"
echo "Base:        $BASE_BRANCH"
echo ""

cd "$REPO_PATH"

# make sure branches exist locally (we'll fetch remote next)
git rev-parse --verify "$FEATURE_BRANCH" >/dev/null 2>&1 \
  || { echo "Feature branch not found"; exit 1; }
git rev-parse --verify "$BASE_BRANCH"   >/dev/null 2>&1 \
  || { echo "Base branch not found";    exit 1; }

# ───────────────────────────────────────────────────────────────────────────────
# fetch the very latest BASE_BRANCH from origin
# ───────────────────────────────────────────────────────────────────────────────
echo "Fetching origin/$BASE_BRANCH…"
git fetch origin "$BASE_BRANCH":"$BASE_BRANCH"

# compute merge-base against origin
BASE_COMMIT=$(git merge-base origin/"$BASE_BRANCH" "$FEATURE_BRANCH")
echo "Using merge-base: $BASE_COMMIT"
echo ""

# ───────────────────────────────────────────────────────────────────────────────
# init_feature_repo (unchanged)
# ───────────────────────────────────────────────────────────────────────────────
init_feature_repo() {
  echo "Initializing feature-tracking repo…"
  cd "$SCRIPT_DIR"
  if [ ! -d .git ]; then
    git init
    cat > README.md << EOF
# Marker API Feature Development Repo

Tracks file copies & implementation guides for the feature branch.
EOF
    cat > .gitignore << EOF
*.tmp
*.temp
.DS_Store
Thumbs.db
EOF
    git add README.md .gitignore
    git commit -m "Initial commit: setup feature repo"
  else
    echo "Feature-tracking repo already exists."
  fi

  if [ -n "$REMOTE_REPO" ] && ! git remote get-url origin >/dev/null 2>&1; then
    git remote add origin "$REMOTE_REPO"
    git branch -M "$DEFAULT_BRANCH"
  fi
}

# ───────────────────────────────────────────────────────────────────────────────
# extract_file_from_branch (unchanged)
# ───────────────────────────────────────────────────────────────────────────────
extract_file_from_branch() {
  local br="$1" f="$2" dest="$3"
  cd "$REPO_PATH"
  mkdir -p "$(dirname "$dest")"
  if git show "$br:$f" > "$dest" 2>/dev/null; then
    return 0
  else
    echo "Warning: cannot extract $f from $br"
    return 1
  fi
}

# ───────────────────────────────────────────────────────────────────────────────
# copy_changed_files (with clean)
# ───────────────────────────────────────────────────────────────────────────────
copy_changed_files() {
  echo "Resetting & copying post-sync files…"
  cd "$SCRIPT_DIR"
  rm -rf "$MODIFIED_FILES_DIR"
  mkdir -p "$MODIFIED_FILES_DIR"

  local changed
  changed=$(cd "$REPO_PATH" && git diff --name-status "$BASE_COMMIT" "$FEATURE_BRANCH")

  local ok=() fail=()
  while IFS=$'\t' read -r st f; do
    case "$st" in
      A|M)
        echo "  • $st $f"
        if extract_file_from_branch "$FEATURE_BRANCH" "$f" "$SCRIPT_DIR/$MODIFIED_FILES_DIR/$f"; then
          ok+=("$st:$f")
        else
          fail+=("$st:$f")
        fi
        ;;
      D)
        [ -f "$MODIFIED_FILES_DIR/$f" ] && rm "$MODIFIED_FILES_DIR/$f"
        ;;
      R*)
        # optionally handle renames
        ;;
    esac
  done <<< "$changed"

  printf "%s\n" "${ok[@]}"  > /tmp/copied.txt
  printf "%s\n" "${fail[@]}" > /tmp/failed.txt
  echo "Copied ${#ok[@]} files, failed ${#fail[@]}."
}

# ───────────────────────────────────────────────────────────────────────────────
# generate_manifest (unchanged)
# ───────────────────────────────────────────────────────────────────────────────
generate_manifest() {
  echo "Generating file manifest…"
  cd "$SCRIPT_DIR"
  cat > "$MANIFEST_FILE" << EOF
# File Manifest

**Generated:** $TIMESTAMP  
**Repo:**      $(basename "$REPO_PATH")  
**Feature:**   $FEATURE_BRANCH  
**Base:**      $BASE_BRANCH  
**Merge-base:** $BASE_COMMIT

## Copied Files
EOF

  if [ -s /tmp/copied.txt ]; then
    while IFS=':' read -r st f; do
      sz=""
      [ -f "$MODIFIED_FILES_DIR/$f" ] && sz=" ($(stat -c%s "$MODIFIED_FILES_DIR/$f") bytes)"
      echo "- **$st**: \`$f\`$sz" >> "$MANIFEST_FILE"
    done < /tmp/copied.txt
  else
    echo "No files copied." >> "$MANIFEST_FILE"
  fi

  if [ -s /tmp/failed.txt ]; then
    echo -e "\n## Failed Copies" >> "$MANIFEST_FILE"
    while IFS=':' read -r st f; do
      echo "- **$st**: \`$f\` (failed)" >> "$MANIFEST_FILE"
    done < /tmp/failed.txt
  fi

  echo -e "\n## Directory Structure\n\`\`\`" >> "$MANIFEST_FILE"
  (cd "$MODIFIED_FILES_DIR" && find . -type f | sed 's/^/  /') >> "$MANIFEST_FILE"
  echo -e "\`\`\`\n*Generated on $TIMESTAMP*" >> "$MANIFEST_FILE"

  rm -f /tmp/copied.txt /tmp/failed.txt
}

# ───────────────────────────────────────────────────────────────────────────────
# commit_changes (unchanged)
# ───────────────────────────────────────────────────────────────────────────────
commit_changes() {
  echo "Committing to feature-tracking repo…"
  cd "$SCRIPT_DIR"
  git add .
  if git diff --staged --quiet; then
    echo "No staged changes."
    return
  fi

  feature_hash=$(cd "$REPO_PATH" && git rev-parse --short "$FEATURE_BRANCH")
  git commit -m "Update from $FEATURE_BRANCH [$feature_hash] post-merge-base $BASE_COMMIT"
  git push origin "$DEFAULT_BRANCH" || echo "Push failed; push manually."

  echo "Recent commits:"
  git --no-pager log --oneline -5
}

# ───────────────────────────────────────────────────────────────────────────────
# build guide
# ───────────────────────────────────────────────────────────────────────────────
build_guide() {
  cd "$SCRIPT_DIR"
  cat > "$OUTPUT_FILE" << EOF
# Implementation Guide: $(echo "$FEATURE_BRANCH" | sed 's/-/ /g' | sed 's/\b\w/\U&/g')

**Generated:** $TIMESTAMP  
**Repo:**      \`$(basename "$REPO_PATH")\`  
**Feature:**   \`$FEATURE_BRANCH\`  
**Base:**      \`$BASE_BRANCH\`  
**Merge-base:** \`$BASE_COMMIT\`

## Summary stats
EOF

  (cd "$REPO_PATH" && git diff --stat     "$BASE_COMMIT" "$FEATURE_BRANCH") >> "$OUTPUT_FILE"
  cat >> "$OUTPUT_FILE" << EOF

## Files changed
EOF

  (cd "$REPO_PATH" && git diff --name-status "$BASE_COMMIT" "$FEATURE_BRANCH") | \
  while read st f; do
    case $st in
      A) echo "- **Added:**    \`$f\` → \`$MODIFIED_FILES_DIR/$f\`" >> "$OUTPUT_FILE" ;;
      M) echo "- **Modified:** \`$f\` → \`$MODIFIED_FILES_DIR/$f\`" >> "$OUTPUT_FILE" ;;
      D) echo "- **Deleted:**  \`$f\`" >> "$OUTPUT_FILE" ;;
      *) echo "- **$st:**       \`$f\`" >> "$OUTPUT_FILE" ;;
    esac
  done

  cat >> "$OUTPUT_FILE" << EOF

## Detailed diff

\`\`\`diff
EOF
  (cd "$REPO_PATH" && git diff "$BASE_COMMIT" "$FEATURE_BRANCH") >> "$OUTPUT_FILE"
  cat >> "$OUTPUT_FILE" << EOF
\`\`\`
EOF
}

# ───────────────────────────────────────────────────────────────────────────────
# main
# ───────────────────────────────────────────────────────────────────────────────
init_feature_repo
copy_changed_files
generate_manifest
build_guide
commit_changes

echo ""
echo "Done."
echo "→ $OUTPUT_FILE"
echo "→ $MANIFEST_FILE"
