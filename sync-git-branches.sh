#!/usr/bin/env bash
set -euo pipefail

git fetch --prune origin

# Detect default remote branch from origin/HEAD
DEFAULT_BRANCH="$(git remote show origin | awk '/HEAD branch/ {print $NF}')"

if [[ -z "${DEFAULT_BRANCH}" || "${DEFAULT_BRANCH}" == "(unknown)" ]]; then
    echo "Could not determine origin's default branch." >&2
    exit 1
fi

# Avoid losing uncommitted work
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Working tree/index is not clean. Commit or stash first." >&2
    exit 1
fi

# Ensure local branch exists and tracks the remote default branch
if git show-ref --verify --quiet "refs/heads/$DEFAULT_BRANCH"; then
    git switch "$DEFAULT_BRANCH"
else
    git switch -c "$DEFAULT_BRANCH" --track "origin/$DEFAULT_BRANCH"
fi

# Force local default branch to match remote exactly
git reset --hard "origin/$DEFAULT_BRANCH"

git remote prune origin

git for-each-ref --format='%(refname:short) %(upstream:track)' refs/heads \
  | awk '$2=="[gone]" {print $1}' \
  | xargs -r git branch -D
