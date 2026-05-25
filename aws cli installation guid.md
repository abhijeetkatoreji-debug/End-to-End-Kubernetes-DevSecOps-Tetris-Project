# AWS CLI Installation Guide

This guide covers installing the AWS CLI in the current Ubuntu-based container environment where the `aws` command is initially unavailable.

## 1. Verify AWS CLI availability

Run:

```bash
command -v aws || echo AWS_CLI_NOT_FOUND
```

If the output is `AWS_CLI_NOT_FOUND`, the AWS CLI is not installed.

## 2. Check Python and pip availability

The AWS CLI can be installed using Python's `pip` if the apt package is not available.

Run:

```bash
command -v python3 || echo PYTHON3_MISSING
command -v pip3 || echo PIP3_MISSING
python3 --version
```

## 3. Install AWS CLI using pip

Install AWS CLI for the current user with:

```bash
python3 -m pip install --user awscli
```

## 4. Add AWS CLI to your PATH

The AWS CLI binary is installed to `~/.local/bin/aws` when using the `--user` install flag.

Make sure `~/.local/bin` is in your shell PATH:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

To persist this change, add the same line to your shell profile file, for example:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

Then reload your shell:

```bash
source ~/.bashrc
```

## 5. Verify installation

Run:

```bash
aws --version
```

Expected output example:

```text
aws-cli/1.45.14 Python/3.12.1 Linux/...
```

## 6. Run AWS configure

After installation, configure AWS credentials and region:

```bash
aws configure
```

Provide your AWS Access Key ID, Secret Access Key, default region name, and default output format when prompted.

## Notes

- If the AWS CLI is still not found after installation, ensure the `PATH` update is active in the current shell session.
- This guide installs AWS CLI version 1 via `pip3` because the `awscli` package was not available from the apt repositories in this environment.


-----
## How to get AWS access keys

1. Sign in to the AWS Management Console.
2. Open the IAM service.
3. Go to `Users` and select the user you want to use.
4. Click the `Security credentials` tab.
5. Under `Access keys`, choose `Create access key`.
6. Copy the `Access key ID` and `Secret access key` immediately.
   - The secret key is shown only once.

> If you don’t have an IAM user yet, create one first and attach the needed permissions.

Then use those values with:

```bash
aws configure
```

and enter:
- AWS Access Key ID
- AWS Secret Access Key
- Default region name
- Default output format