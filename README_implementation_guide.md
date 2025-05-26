# Implementation Guide Generator

This directory contains scripts to generate comprehensive implementation guides from git diffs between branches. The scripts are designed to be run from outside the target repository, making them portable and reusable across different projects.

## Files

1. **`generate_implementation_guide.sh`** - Shell script for quick generation
2. **`generate_implementation_guide.py`** - Python script with advanced features and error handling
3. **`implementation_guide.md`** - Generated implementation guide (example output)
4. **`README_implementation_guide.md`** - This documentation file

## Quick Start

### Using the Shell Script (Recommended for simplicity)

```bash
# Navigate to the script directory
cd /path/to/markdown_api_feature

# Generate guide for a repository (using default branches)
./generate_implementation_guide.sh /path/to/your-repository

# Generate guide with custom branches
./generate_implementation_guide.sh /path/to/your-repository feature-branch base-branch

# Example: Generate guide for the open-webui project
./generate_implementation_guide.sh ../open-webui marker-api-content-extraction main
```

### Using the Python Script (Recommended for flexibility)

```bash
# Navigate to the script directory
cd /path/to/markdown_api_feature

# Generate guide for a repository (using default branches)
python3 generate_implementation_guide.py /path/to/your-repository

# Generate guide with custom branches
python3 generate_implementation_guide.py /path/to/your-repository feature-branch base-branch

# Example: Generate guide for the open-webui project
python3 generate_implementation_guide.py ../open-webui marker-api-content-extraction main
```

## Command Line Arguments

### Shell Script
```bash
./generate_implementation_guide.sh [repository_path] [feature_branch] [base_branch]
```

### Python Script
```bash
python3 generate_implementation_guide.py [repository_path] [feature_branch] [base_branch]
```

**Parameters:**
- `repository_path` - Path to the git repository (required)
- `feature_branch` - Feature branch name (optional, defaults to "marker-api-content-extraction")
- `base_branch` - Base branch name (optional, defaults to "main")

## Usage Examples

### Basic Usage
```bash
# Generate guide for repository in current directory
./generate_implementation_guide.sh .

# Generate guide for specific repository
./generate_implementation_guide.sh /home/user/my-project

# Generate guide for relative path
./generate_implementation_guide.sh ../my-project
```

### Custom Branches
```bash
# Compare feature branch with develop
./generate_implementation_guide.sh /path/to/repo my-feature develop

# Compare release branch with main
python3 generate_implementation_guide.py /path/to/repo release/v2.0 main

# Compare two arbitrary branches
./generate_implementation_guide.sh /path/to/repo experimental stable
```

### Real-world Examples
```bash
# For the open-webui project
./generate_implementation_guide.sh ../open-webui marker-api-content-extraction main

# For a React project
python3 generate_implementation_guide.py /home/user/react-app feature/new-component main

# For a Python project
./generate_implementation_guide.sh /projects/python-api feature/auth-system develop
```

## What Gets Generated

The implementation guide includes:

1. **Header Information**
   - Generation timestamp
   - Repository name
   - Branch names being compared

2. **Overview** - Summary of what changed between branches

3. **Summary Statistics** - Number of files changed, insertions, deletions

4. **Files Changed** - Categorized list of:
   - Added files
   - Modified files
   - Deleted files
   - Renamed files

5. **Detailed Changes** - Complete diff output in markdown format

6. **Implementation Notes** - Instructions and git commands for reference

## Example Output

```markdown
# Implementation Guide: Marker Api Content Extraction

**Generated on:** 2025-05-26 10:29:07  
**Repository:** `open-webui`  
**Feature Branch:** `marker-api-content-extraction`  
**Base Branch:** `main`

## Summary Statistics
 6 files changed, 87 insertions(+), 607 deletions(-)

## Files Changed
- **Modified:** `backend/open_webui/config.py`
- **Deleted:** `backend/open_webui/retrieval/loaders/datalab_marker_loader.py`
- **Modified:** `backend/open_webui/main.py`
...
```

## Features

### Shell Script Features
- Simple one-command execution
- Repository path validation
- Branch existence verification
- Automatic file detection
- Markdown formatting
- Timestamped output
- Error handling

### Python Script Features
- Advanced error handling and validation
- Path resolution using pathlib
- Custom branch support
- Detailed logging and feedback
- Flexible command-line arguments
- Cross-platform compatibility
- Repository name detection

## Error Handling

Both scripts include comprehensive error handling:

### Common Validations
- Repository path exists
- Target directory is a git repository
- Both branches exist in the repository
- Git commands execute successfully

### Error Messages
```bash
Error: Repository path '/invalid/path' does not exist.
Error: '/path/to/dir' is not a git repository.
Error: Branch 'nonexistent-branch' not found in repository.
```

## Requirements

- **Git repository** - Target must be a valid git repository
- **Bash shell** - For shell script execution
- **Python 3.6+** - For Python script execution
- **Git CLI** - Must be installed and accessible
- **Read access** - To both branches in the repository

## Customization

### Changing Default Branches

Edit the scripts to change default branches:

**Shell script:**
```bash
FEATURE_BRANCH="your-default-feature-branch"
BASE_BRANCH="your-default-base-branch"
```

**Python script:**
```python
feature_branch = "your-default-feature-branch"
base_branch = "your-default-base-branch"
```

### Changing Output Format

The scripts generate markdown by default. To modify:

1. Change the `OUTPUT_FILE` variable for different extensions
2. Modify the content generation sections for different formats
3. Adjust the diff formatting as needed

## Troubleshooting

### Common Issues

1. **Repository not found**
   ```bash
   Error: Repository path '/path/to/repo' does not exist.
   ```
   - Verify the repository path is correct
   - Use absolute paths to avoid confusion
   - Check file permissions

2. **Not a git repository**
   ```bash
   Error: '/path/to/dir' is not a git repository.
   ```
   - Ensure the target directory contains a `.git` folder
   - Initialize git repository if needed: `git init`

3. **Branch not found**
   ```bash
   Error: Branch 'feature-branch' not found in repository.
   ```
   - Check branch names for typos
   - List available branches: `git branch -a`
   - Ensure branches are fetched: `git fetch --all`

4. **Permission denied**
   ```bash
   ./generate_implementation_guide.sh: Permission denied
   ```
   - Make scripts executable: `chmod +x *.sh`

5. **No changes detected**
   - Verify you're comparing the correct branches
   - Check if branches are identical
   - Ensure branches have different commits

### Debug Tips

1. **Verify git access:**
   ```bash
   cd /path/to/repository
   git status
   git branch -a
   ```

2. **Test git diff manually:**
   ```bash
   cd /path/to/repository
   git diff --stat branch1 branch2
   ```

3. **Check script permissions:**
   ```bash
   ls -la generate_implementation_guide.*
   ```

## Use Cases

- **Code Reviews** - Generate comprehensive change summaries for review
- **Documentation** - Create implementation guides for new features
- **Deployment** - Track changes between releases or environments
- **Onboarding** - Help new team members understand recent changes
- **Release Notes** - Generate detailed change logs
- **Compliance** - Document changes for audit purposes

## Git Commands Reference

The scripts use these git commands internally:

```bash
# Verify branch exists
git rev-parse --verify branch-name

# Get diff statistics
git diff --stat branch1 branch2

# Get changed files with status
git diff --name-status branch1 branch2

# Get complete diff
git diff branch1 branch2
```

## Output Location

Both scripts generate `implementation_guide.md` in the **current working directory** (where you run the script), not in the target repository. This keeps the generated documentation separate from the source code.

## Integration with CI/CD

These scripts can be integrated into CI/CD pipelines:

```yaml
# Example GitHub Actions workflow
- name: Generate Implementation Guide
  run: |
    cd /path/to/scripts
    ./generate_implementation_guide.sh ${{ github.workspace }} ${{ github.head_ref }} main
    
- name: Upload Guide as Artifact
  uses: actions/upload-artifact@v2
  with:
    name: implementation-guide
    path: implementation_guide.md
```

---

*Generated by implementation guide generator scripts*
