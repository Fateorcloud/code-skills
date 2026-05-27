---
name: git-push
description: Use this skill when preparing, verifying, or troubleshooting Git pushes to GitHub over SSH, especially for first-time repository push setup, global Git identity checks, SSH key creation or validation, GitHub SSH key binding, remote URL checks, commit readiness, and safe push commands.
---

# Git Push

## Overview

Use this skill to make GitHub push work repeatably and safely. Prefer SSH remotes, verify identity and authentication before pushing, and avoid rewriting history unless the user explicitly asks for it.

## Default Workflow

### 1. Inspect the Repository

Run read-only checks first:

```bash
git status --short --branch
git remote -v
git branch --show-current
```

Confirm:

- current branch name
- whether there are uncommitted changes
- whether `origin` exists
- whether the remote is SSH (`git@github.com:owner/repo.git`) or HTTPS

If the repository has no remote, ask for or infer the GitHub repository URL before adding one.

### 2. Check Git Identity

Read the current global identity:

```bash
git config --global user.name
git config --global user.email
```

For this workspace, the known user identity is:

```bash
git config --global user.name "Fateorcloud"
git config --global user.email "1658749123@qq.com"
```

Only change global config when the user asks for setup or when the values are empty/wrong for the requested GitHub account. Tell the user before changing global config because it affects all repositories.

### 3. Check or Create SSH Key

Look for an existing public key before creating a new one:

```bash
ls ~/.ssh
```

Common public key files include:

- `~/.ssh/id_rsa.pub`
- `~/.ssh/id_ed25519.pub`

If no suitable key exists and the user wants setup, create one. Prefer modern Ed25519 unless the user explicitly requests RSA:

```bash
ssh-keygen -t ed25519 -C "1658749123@qq.com"
```

Use RSA only for compatibility with the user's documented setup:

```bash
ssh-keygen -t rsa -C "1658749123@qq.com"
```

When prompted for path and passphrase, pressing Enter accepts defaults and can create passwordless SSH login. Do not overwrite an existing key file without explicit confirmation.

### 4. Bind the Public Key in GitHub

Show the public key path and print the `.pub` file only when the user needs to copy it:

```bash
cat ~/.ssh/id_rsa.pub
```

On Windows, the file is usually under:

```text
C:\Users\<username>\.ssh\id_rsa.pub
```

The user should add the public key content in GitHub:

```text
GitHub -> Settings -> SSH and GPG keys -> New SSH key
```

Never expose or copy private key files such as `id_rsa` or `id_ed25519`.

### 5. Verify GitHub SSH Access

Run:

```bash
ssh -T git@github.com
```

Expected success looks like a GitHub greeting that says authentication succeeded. On first connection, accept the host fingerprint only when it is clearly for `github.com`.

If verification fails:

- ensure the public key was added to GitHub
- check that the SSH agent can see the key
- check `~/.ssh/config` only if multiple keys/accounts are involved
- confirm the remote URL uses SSH

### 6. Prepare and Push

Review changes before committing:

```bash
git status --short
git diff
```

Commit only intentional files:

```bash
git add <paths>
git commit -m "<clear message>"
```

Push the current branch:

```bash
git push -u origin <branch>
```

For later pushes on the same branch:

```bash
git push
```

Avoid `--force`. Use `--force-with-lease` only when the user explicitly asks to rewrite remote history and the risk is understood.

## Remote URL Helpers

Convert HTTPS origin to SSH:

```bash
git remote set-url origin git@github.com:<owner>/<repo>.git
```

Add SSH origin when missing:

```bash
git remote add origin git@github.com:<owner>/<repo>.git
```

Verify afterward:

```bash
git remote -v
```

## Completion Report

When done, report:

- Git identity status
- SSH verification result
- remote URL
- branch pushed
- commit hash if a commit was created
- any remaining manual action, such as adding the public key in GitHub
