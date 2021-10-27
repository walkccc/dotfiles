#!/bin/bash

set -e

ALIAS_NAME="$1"
REPO_NAME="$2"

if [[ -z "$ALIAS_NAME" || -z "$REPO_NAME" ]]; then
  echo "Usage: add-repo-shortcut <alias> <repo>"
  exit 1
fi

ALIAS_FILE="$HOME/.config/zsh/init/aliases/raycast.sh"
RAYCAST_DIR="$HOME/.config/raycast/commands"
RAYCAST_FILE="$RAYCAST_DIR/open-walkccc:${REPO_NAME}.sh"

mkdir -p "$RAYCAST_DIR"

NEW_ALIAS="alias $ALIAS_NAME=\"cd \$HOME/Repos/$REPO_NAME\""

# --- Add alias safely ---
if grep -q "alias $ALIAS_NAME=" "$ALIAS_FILE"; then
  echo "Alias $ALIAS_NAME already exists. Skipping."
else
  {
    # Extract header (everything before first alias)
    awk '/^alias /{exit} {print}' "$ALIAS_FILE"

    # Existing aliases + new one, sorted
    (grep '^alias ' "$ALIAS_FILE"; echo "$NEW_ALIAS") | sort
  } > "$ALIAS_FILE.tmp"

  mv "$ALIAS_FILE.tmp" "$ALIAS_FILE"
  echo "Added alias: $ALIAS_NAME"
fi

# --- Raycast script ---
cat > "$RAYCAST_FILE" <<EOF
#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open walkccc/$REPO_NAME
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author Peng-Yu Chen
# @raycast.authorURL pengyuc.com

code \$HOME/Repos/$REPO_NAME
EOF

chmod +x "$RAYCAST_FILE"

echo "Created Raycast command: $RAYCAST_FILE"
