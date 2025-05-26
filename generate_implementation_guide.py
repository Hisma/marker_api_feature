#!/usr/bin/env python3
"""
Implementation Guide Generator
Generates a comprehensive implementation guide from git diff between branches
Designed to be run from outside the target repository
"""

import subprocess
import sys
import os
from datetime import datetime
from pathlib import Path

class ImplementationGuideGenerator:
    def __init__(self, repo_path=".", feature_branch="marker-api-content-extraction", base_branch="main"):
        self.repo_path = Path(repo_path).resolve()
        self.feature_branch = feature_branch
        self.base_branch = base_branch
        self.output_file = "implementation_guide.md"
        self.timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    def validate_repository(self):
        """Validate that the repository path exists and is a git repository"""
        if not self.repo_path.exists():
            print(f"Error: Repository path '{self.repo_path}' does not exist.")
            return False
        
        if not (self.repo_path / ".git").exists():
            print(f"Error: '{self.repo_path}' is not a git repository.")
            return False
        
        return True
    
    def run_git_command(self, command):
        """Run a git command in the repository directory and return the output"""
        try:
            result = subprocess.run(
                command, 
                shell=True, 
                capture_output=True, 
                text=True, 
                check=True,
                cwd=self.repo_path
            )
            return result.stdout.strip()
        except subprocess.CalledProcessError as e:
            print(f"Error running git command: {command}")
            print(f"Error: {e.stderr}")
            return None
    
    def check_branches_exist(self):
        """Check if both branches exist"""
        # Check feature branch
        if self.run_git_command(f"git rev-parse --verify {self.feature_branch}") is None:
            print(f"Error: Branch '{self.feature_branch}' not found in repository.")
            return False
        
        # Check base branch
        if self.run_git_command(f"git rev-parse --verify {self.base_branch}") is None:
            print(f"Error: Branch '{self.base_branch}' not found in repository.")
            return False
        
        return True
    
    def get_diff_stats(self):
        """Get diff statistics"""
        return self.run_git_command(f"git diff --stat {self.base_branch} {self.feature_branch}")
    
    def get_changed_files(self):
        """Get list of changed files with their status"""
        output = self.run_git_command(f"git diff --name-status {self.base_branch} {self.feature_branch}")
        if not output:
            return []
        
        files = []
        for line in output.split('\n'):
            if line.strip():
                parts = line.split('\t', 1)
                if len(parts) >= 2:
                    status = parts[0]
                    filename = parts[1]
                    status_map = {
                        'A': 'Added',
                        'M': 'Modified',
                        'D': 'Deleted',
                        'R': 'Renamed',
                        'C': 'Copied'
                    }
                    status_text = status_map.get(status[0], status)
                    files.append((status_text, filename))
        return files
    
    def get_full_diff(self):
        """Get the complete diff"""
        return self.run_git_command(f"git diff {self.base_branch} {self.feature_branch}")
    
    def format_title(self, branch_name):
        """Convert branch name to a readable title"""
        return ' '.join(word.capitalize() for word in branch_name.replace('-', ' ').replace('_', ' ').split())
    
    def generate_guide(self):
        """Generate the complete implementation guide"""
        print("=== Implementation Guide Generator ===")
        print(f"Repository path: {self.repo_path}")
        print(f"Feature branch: {self.feature_branch}")
        print(f"Base branch: {self.base_branch}")
        print(f"Output file: {self.output_file}")
        print("")
        
        # Validate repository
        if not self.validate_repository():
            return False
        
        # Check if branches exist
        if not self.check_branches_exist():
            return False
        
        # Collect data
        print("Collecting diff statistics...")
        diff_stats = self.get_diff_stats()
        
        print("Getting changed files...")
        changed_files = self.get_changed_files()
        
        print("Generating detailed diff...")
        full_diff = self.get_full_diff()
        
        if full_diff is None:
            print("Error: Could not generate diff")
            return False
        
        # Generate the markdown file
        repo_name = self.repo_path.name
        title = self.format_title(self.feature_branch)
        
        with open(self.output_file, 'w') as f:
            f.write(f"""# Implementation Guide: {title}

**Generated on:** {self.timestamp}  
**Repository:** `{repo_name}`  
**Feature Branch:** `{self.feature_branch}`  
**Base Branch:** `{self.base_branch}`

## Overview

This document contains the complete diff between the `{self.feature_branch}` branch and the `{self.base_branch}` branch, showing all changes made to implement the feature.

## Summary Statistics

```
{diff_stats if diff_stats else 'No changes detected'}
```

## Files Changed

The following files were modified, added, or deleted:

""")
            
            if changed_files:
                for status, filename in changed_files:
                    f.write(f"- **{status}:** `{filename}`\n")
            else:
                f.write("No files changed.\n")
            
            f.write(f"""

---

## Detailed Changes

The following sections show the complete diff for each file:

```diff
{full_diff}
```

---

## Implementation Notes

### How to Use This Guide

1. **Review the Summary Statistics** to understand the scope of changes
2. **Check the Files Changed** section to see which files were affected
3. **Use the Detailed Changes** section to see exactly what was modified
4. **Apply changes manually** or use this as reference for code review

### Git Commands Used

- **Generate this diff:** `git diff {self.base_branch} {self.feature_branch}`
- **View file list:** `git diff --name-status {self.base_branch} {self.feature_branch}`
- **View statistics:** `git diff --stat {self.base_branch} {self.feature_branch}`

### Regenerating This Guide

To regenerate this guide with updated changes, run:
```bash
# From the script directory
python3 generate_implementation_guide.py /path/to/repository

# With custom branches
python3 generate_implementation_guide.py /path/to/repository feature-branch base-branch
```

### Usage Examples

```bash
# Generate guide for repository in current directory
python3 generate_implementation_guide.py .

# Generate guide for specific repository
python3 generate_implementation_guide.py /path/to/my-project

# Generate guide with custom branches
python3 generate_implementation_guide.py /path/to/my-project my-feature main

# Generate guide for relative path
python3 generate_implementation_guide.py ../my-project
```

---

*Generated by implementation guide script on {self.timestamp}*
""")
        
        print(f"Implementation guide generated successfully: {self.output_file}")
        print(f"File size: {sum(1 for line in open(self.output_file))} lines")
        return True

def main():
    # Parse command line arguments
    if len(sys.argv) == 1:
        # No arguments - use current directory with default branches
        repo_path = "."
        feature_branch = "marker-api-content-extraction"
        base_branch = "main"
    elif len(sys.argv) == 2:
        # Repository path only
        repo_path = sys.argv[1]
        feature_branch = "marker-api-content-extraction"
        base_branch = "main"
    elif len(sys.argv) == 4:
        # Repository path and both branches
        repo_path = sys.argv[1]
        feature_branch = sys.argv[2]
        base_branch = sys.argv[3]
    else:
        print("Usage: python3 generate_implementation_guide.py [repository_path] [feature_branch] [base_branch]")
        print("")
        print("Examples:")
        print("  python3 generate_implementation_guide.py")
        print("  python3 generate_implementation_guide.py /path/to/repository")
        print("  python3 generate_implementation_guide.py ../my-project my-feature main")
        print("  python3 generate_implementation_guide.py . feature-branch develop")
        sys.exit(1)
    
    # Generate the guide
    generator = ImplementationGuideGenerator(repo_path, feature_branch, base_branch)
    success = generator.generate_guide()
    
    if success:
        print("\nTo view the guide:")
        print(f"  cat {generator.output_file}")
        print("  # or open in your preferred markdown viewer")
    else:
        sys.exit(1)

if __name__ == "__main__":
    main()
