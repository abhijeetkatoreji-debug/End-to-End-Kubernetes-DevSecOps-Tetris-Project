# Issue Resolution Summary

This document describes the issues we faced in this project and the exact steps used to resolve them.

## 1. AWS CLI was missing in the container

### Problem
The command `aws configure` failed because `aws` was not installed.

### Resolution
Installed AWS CLI using Python `pip` because the `awscli` package was not available in apt.

### Commands
```bash
python3 -m pip install --user awscli
export PATH="$HOME/.local/bin:$PATH"
aws --version
```

### Notes
- The AWS CLI binary was installed to `~/.local/bin/aws`.
- Add `export PATH="$HOME/.local/bin:$PATH"` to `~/.bashrc` if needed.

---

## 2. Terraform was not installed

### Problem
The workspace did not have the `terraform` command installed.

### Resolution
Installed Terraform from HashiCorp release archives.

### Commands
```bash
sudo apt-get install -y unzip curl
cd /tmp
curl -fsSL https://releases.hashicorp.com/terraform/1.15.4/terraform_1.15.4_linux_amd64.zip -o terraform.zip
unzip -o terraform.zip
sudo mv terraform /usr/local/bin/terraform
sudo chmod +x /usr/local/bin/terraform
terraform version
```

### Notes
- Terraform was installed to `/usr/local/bin/terraform`.
- The installed version was `v1.15.4`.

---

## 3. Git push failed because of a large tracked Terraform provider file

### Problem
GitHub rejected the push with the error:

- `File Jenkins-Server-TF/.terraform/providers/registry.terraform.io/hashicorp/aws/6.46.0/linux_amd64/terraform-provider-aws_v6.46.0_x5 is 854.34 MB; this exceeds GitHub's file size limit of 100.00 MB`

This happened because a Terraform plugin binary was committed into the repo under `.terraform/`.

### Resolution
Removed `.terraform/` from git tracking, added ignore rules, and rewrote history to remove the large file.

### Commands
```bash
git rm -r --cached Jenkins-Server-TF/.terraform
```

If history rewrite was needed:
```bash
git filter-branch --force --index-filter \
  'git rm -r --cached --ignore-unmatch Jenkins-Server-TF/.terraform' \
  --prune-empty --tag-name-filter cat -- --all

git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

Then push:
```bash
git fetch origin main
git push origin main --force-with-lease
```

### Notes
- `.gitignore` must contain:
```text
.terraform/
*.tfstate
*.tfstate.*
```
- Local plugin folders and state files should not be tracked in Git.

---

## 4. Jenkins pipeline checkout branch mismatch

### Problem
The Jenkins pipeline was configured to checkout `master`, but the repository uses `main`.

### Resolution
Updated the Jenkinsfile branch configuration from `master` to `main`.

### Changed code
```groovy
git branch: 'main', url: 'https://github.com/abhijeetkatoreji-debug/End-to-End-Kubernetes-DevSecOps-Tetris-Project.git'
```

---

## 5. Terraform init failed in Jenkins due provider lock mismatch

### Problem
`terraform init` failed with:

- `locked provider registry.terraform.io/hashicorp/aws 5.31.0 does not match configured version constraint >= 5.49.0; must use terraform init -upgrade`

This occurred because `EKS-TF/.terraform.lock.hcl` had an outdated locked provider version.

### Resolution
Re-ran Terraform init with upgrade locally to update the lock file, then committed the updated `.terraform.lock.hcl`.

### Commands
```bash
cd /workspaces/End-to-End-Kubernetes-DevSecOps-Tetris-Project/EKS-TF
terraform init -upgrade -backend=false
```

### Result
The lock file was updated to use:
- provider version `6.46.0`
- constraints `>= 5.49.0`

---

## 6. Final commit and push

### Commands
```bash
git add EKS-TF/.terraform.lock.hcl Jenkins-Pipeline-Code/Jenkinsfile-EKS-Terraform .gitignore
git commit -m 'Fix Terraform provider lock version and ignore local .terraform directories'
git push origin main
```

---

## Summary

The main issues were:

1. Missing AWS CLI in the environment.
2. Missing Terraform installation.
3. Committed Terraform provider binary inside `.terraform/` causing GitHub push failure.
4. Jenkins pipeline checking out the wrong branch.
5. Provider lock file mismatch causing `terraform init` to fail.

The resolution was:

- Install AWS CLI and Terraform.
- Ignore `.terraform/` and local state files.
- Remove the large file from Git history.
- Fix the Jenkinsfile branch.
- Update the provider lock file with `terraform init -upgrade`.
