#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Reset LeetCode
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author Peng-Yu Chen
# @raycast.authorURL pengyuc.com

gh repo edit walkccc/LeetCode --default-branch gh-pages &&
  gh repo edit walkccc/LeetCode --default-branch main &&
  bash <(curl -s https://raw.githubusercontent.com/walkccc/snippets/main/delete-workflow-runs.sh) all walkccc/LeetCode &&
  cd ~/Repos/LeetCode &&
  git fetch origin main && git reset --hard origin/main
