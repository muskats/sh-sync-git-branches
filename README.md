# sh-sync-git-branches

Synchronize the local default branch with `origin/HEAD` and remove stale local branches.

This is a cleanup utility for personal development. It is **destructive** on the local default branch: it **hard-resets** that branch to match the remote.

## What it does

1) Fetches from `origin`
2) Detects the remote default branch
3) Checks out the local default branch, creating it if needed
4) Hard-resets the local default branch to `origin/<default-branch>`
5) Prunes stale remote-tracking references
6) Deletes local branches without upstream branches

## Safety

- Refuses to run if the working tree or index is dirty
- Will **discard local changes** on the default branch
- Does not delete untracked files
- Assumes `origin` is the source of truth

## Usage

From inside a Git repository:

```bash
./sync-git-branches.sh
```

### Install as a command

To make sync-git-branches available from anywhere, keep a stable copy of the script outside the working repository.

1) Copy the script to a safe location

```bash
mkdir -p ~/bin
cp ./sync-git-branches.sh ~/bin/sync-git-branches
chmod +x ~/bin/sync-git-branches
```

2) Make sure ~/bin is on your PATH

```bash
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
```

3) Reload your shell

```bash
source ~/.bashrc
```

### Recommended workflow

- Keep the script in a stable location outside your working repository
- Update the stable copy manually when you want a new version
- Run it only inside repositories where you want local cleanup and branch pruning