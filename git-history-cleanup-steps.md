# Git History Cleanup Steps

This document summarizes the exact commands used to clean the repository history and remove the large tracked Terraform plugin file.

## Problem

A large file was rejected by GitHub during push:

- `Jenkins-Server-TF/.terraform/providers/registry.terraform.io/hashicorp/aws/6.46.0/linux_amd64/terraform-provider-aws_v6.46.0_x5`
- File size: `854.34 MB`
- GitHub limit: `100 MB`

The issue was caused by a tracked `.terraform` directory inside the repository.

## Steps performed

### 1. Check repository status

```bash
git status --short
git branch -vv
git ls-files | grep '^Jenkins-Server-TF/\.terraform' || true
```

### 2. Search git history for tracked `.terraform` paths

```bash
git rev-list --all --objects | grep '\.terraform' | head -50
```

This confirmed the bad file and related `.terraform` history entries.

### 3. Rewrite git history to remove the `.terraform` directory

`git filter-repo` was not available, so the history rewrite used `git filter-branch`:

```bash
git filter-branch --force --index-filter \
  'git rm -r --cached --ignore-unmatch Jenkins-Server-TF/.terraform' \
  --prune-empty --tag-name-filter cat -- --all
```

### 4. Clean up reflog and garbage collect old objects

```bash
git reflog expire --expire=now --all
git gc --prune=now --aggressive
git rev-list --all --objects | grep '\.terraform' || true
```

This verified that the `.terraform` files were removed from history.

### 5. Push the cleaned branch to GitHub

First fetch the latest remote state:

```bash
git fetch origin main
```

Then force-push the cleaned branch using lease safety:

```bash
git push origin main --force-with-lease
```

## Notes

- The `.gitignore` rule was also added to prevent future `.terraform` content from being committed:

```text
# ignore Terraform local state and plugins
*.tfstate
*.tfstate.*
.terraform/
```

- The cleanup targeted repository-local `.terraform` files in `Jenkins-Server-TF/`, not the system-installed AWS CLI or Terraform binaries.
- The large file was removed from history, and the branch was successfully pushed after the rewrite.
