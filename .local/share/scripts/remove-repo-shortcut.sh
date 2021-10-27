#!/bin/bash

set -e

REPO_NAME="$1"

if [[ -z "$REPO_NAME" ]]; then
  echo "Usage: remove-repo-shortcut <repo>"
  echo "Example: rrs appshapr"
  exit 1
fi

ALIAS_FILE="$HOME/.config/zsh/init/aliases/raycast.sh"
RAYCAST_FILE="$HOME/.config/raycast/commands/open-walkccc:${REPO_NAME}.sh"

# --- Remove alias (match by repo path instead of alias name) ---
if grep -q "\$HOME/Repos/$REPO_NAME" "$ALIAS_FILE"; then
  sed -i '' "\|cd \$HOME/Repos/$REPO_NAME|d" "$ALIAS_FILE"
  echo "Removed alias for repo: $REPO_NAME"
else
  echo "No alias found for repo: $REPO_NAME"
fi

# --- Remove Raycast script ---
if [[ -f "$RAYCAST_FILE" ]]; then
  rm "$RAYCAST_FILE"
  echo "Removed Raycast command: $RAYCAST_FILE"
else
  echo "Raycast script not found."
fi
