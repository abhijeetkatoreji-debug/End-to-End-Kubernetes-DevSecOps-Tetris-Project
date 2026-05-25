# Terraform Installation Guide

This guide covers installing Terraform in the current Ubuntu-based container environment where the `terraform` command is initially unavailable.

## 1. Verify Terraform availability

Run:

```bash
command -v terraform || echo TERRAFORM_NOT_FOUND
terraform version 2>/dev/null || true
```

If the output is `TERRAFORM_NOT_FOUND`, Terraform is not installed.

## 2. Install dependencies

Make sure `curl` and `unzip` are available. In most Ubuntu containers, `unzip` should already be installed.

Run:

```bash
sudo apt-get update
sudo apt-get install -y unzip curl
```

## 3. Download Terraform

Download a stable Terraform release from HashiCorp. For example, use version `1.15.4`:

```bash
cd /tmp
curl -fsSL https://releases.hashicorp.com/terraform/1.15.4/terraform_1.15.4_linux_amd64.zip -o terraform.zip
```

## 4. Install Terraform binary

Unzip the downloaded archive and move the executable into `/usr/local/bin`:

```bash
unzip -o terraform.zip
sudo mv terraform /usr/local/bin/terraform
sudo chmod +x /usr/local/bin/terraform
```

## 5. Verify installation

Run:

```bash
terraform version
```

Expected output example:

```text
Terraform v1.15.4
on linux_amd64
```

## 6. Use Terraform

Navigate to your project and initialize Terraform:

```bash
cd /workspaces/End-to-End-Kubernetes-DevSecOps-Tetris-Project
terraform init
```

## Notes

- If the download URL changes, check HashiCorp releases at `https://releases.hashicorp.com/terraform/`.
- Use `sudo` when moving the binary to a system-wide location like `/usr/local/bin`.
- If you want a different version, update the URL accordingly.
