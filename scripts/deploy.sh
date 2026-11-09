#!/usr/bin/env bash
# Glance Dashboard deploy: commit to branch `ultra` + push to GitHub from this
# machine, then pull the ultra branch on the "ultra" server.
# Usage: bash scripts/deploy.sh ["commit message"]
set -euo pipefail
cd "$(dirname "$0")/.."

MSG="${1:-Hermes task update $(date '+%Y-%m-%d %H:%M')}"

git checkout ultra
git add -A

if git diff --cached --quiet; then
    echo "Nothing to commit — local repo already clean on ultra."
else
    git commit -m "$MSG"
    git push origin ultra
    echo "Pushed to GitHub (origin/ultra)."
fi

ssh ultra 'cd ~/.config/glance/dashboard && git pull --ff-only origin ultra'
echo "Deploy complete: ultra server is in sync with origin/ultra."
