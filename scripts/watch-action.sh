#!/usr/bin/env bash
# Waits for the GitHub Actions run triggered by HEAD to appear, then
# streams it to completion and exits non-zero if it fails.
set -uo pipefail
cd "$(dirname "$0")/.."

sha=$(git rev-parse HEAD)
id=""
for i in $(seq 1 20); do
  id=$(gh run list --commit "$sha" --limit 1 --json databaseId --jq '.[0].databaseId' 2>/dev/null)
  [ -n "$id" ] && break
  sleep 3
done

if [ -z "$id" ]; then
  echo "No GitHub Actions run found for $sha after 60s"
  exit 1
fi

gh run watch "$id" --exit-status
