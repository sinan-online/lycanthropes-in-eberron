#!/usr/bin/env bash
# Polls origin/main for the CI bot's "Update compiled PDF" commit, then
# fast-forward pulls and reopens the PDF in VS Code so the PDF viewer
# extension picks up the new version.
set -uo pipefail
cd "$(dirname "$0")/.."

CODE=code
command -v "$CODE" >/dev/null 2>&1 || CODE="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"

last_sha=$(git rev-parse origin/main)
echo "Watching origin/main for compiled PDF updates (starting at $last_sha)"

while true; do
  if git fetch origin main --quiet 2>/dev/null; then
    new_sha=$(git rev-parse origin/main)
    if [ "$new_sha" != "$last_sha" ]; then
      if git log --format=%s "$last_sha..$new_sha" | grep -q "Update compiled PDF"; then
        if git pull --ff-only origin main --quiet 2>/dev/null; then
          "$CODE" -r pdf/lycanthropes-in-eberron.pdf
          echo "Pulled and reopened PDF at $new_sha ($(date +%H:%M:%S))"
        else
          echo "New PDF commit $new_sha detected but fast-forward pull failed - check local branch state"
        fi
      fi
      last_sha=$new_sha
    fi
  fi
  sleep 20
done
