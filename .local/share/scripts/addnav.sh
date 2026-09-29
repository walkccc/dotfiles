# !/bin/bash
#
# addnav - Manage navigation aliases and Raycast scripts for ~/Repos projects.
#
# Creates a shell alias (cd shortcut) and a Raycast script (opens in VS Code)
# for a given repo under ~/Repos.
#
# Usage:
#   addnav <alias> <repo> <keyword>   Add an entry directly
#   addnav                            Add an entry interactively
#   addnav remove                     Remove an entry interactively
#
# Examples:
#   addnav clc LeetCode vlc           Creates alias 'clc' -> ~/Repos/LeetCode
#   addnav cz Zestimer vz             Creates alias 'cz' -> ~/Repos/Zestimer
#
# Files:
#   ~/.config/zsh/init/navigation.sh      Shell aliases
#   ~/.config/raycast/scripts/commands    Raycast scripts
#

set -e

AUTHOR="Peng-Yu Chen"
NAV_FILE="$HOME/.config/zsh/init/navigation.sh"
RAYCAST_DIR="$HOME/.config/raycast/commands"

mkdir -p "$(dirname "$NAV_FILE")"
mkdir -p "$RAYCAST_DIR"

# Prints all registered aliases with line numbers.
function list_aliases() {
  if [[ ! -f "$NAV_FILE" ]]; then
    echo "No aliases yet."
    exit 0
  fi
  grep '^alias ' "$NAV_FILE" | sed 's/alias //' | nl
}

# Extracts the alias name from an alias definition line.
# e.g. 'alias lc="cd ..."' -> 'lc'
function extract_alias_name() {
  echo "$1" | cut -d'=' -f1
}

# Extracts the repo folder name from an alias definition line.
# e.g. 'alias lc="cd $HOME/Repos/LeetCode"' -> 'LeetCode'
function extract_repo_name() {
  echo "$1" | sed -E 's/.*Repos\/([^"]+).*/\1/'
}

# Adds a navigation entry: a shell alias and a Raycast script.
# Args: $1=alias name, $2=repo folder, $3=raycast keyword
# Exits with error if the alias already exists.
function add_entry() {
  local name=$1
  local repo=$2
  local keyword=$3

  if grep -q "alias $name=" "$NAV_FILE" 2>/dev/null; then
    echo "Alias '$name' already exists."
    exit 1
  fi

  echo "alias $name=\"cd \$HOME/Repos/$repo\"" >>"$NAV_FILE"

  local script_path="$RAYCAST_DIR/$name.sh"

  cat >"$script_path" <<EOF
#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open $repo in VS Code
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.keyword $keyword

# Documentation:
# @raycast.author $AUTHOR

code \$HOME/Repos/$repo
EOF

  chmod +x "$script_path"

  echo "Added:"
  echo "  Alias: $name"
  echo "  Repo:  $repo"
  echo "  Key:   $keyword"
}

# Prompts the user for alias name, repo folder, and keyword, then delegates
# to add_entry.
function interactive_add() {
  read -p "Alias name: " name
  read -p "Repo folder (under ~/Repos): " repo
  read -p "Raycast keyword: " keyword
  add_entry "$name" "$repo" "$keyword"
}

# Lists existing aliases and prompts the user to pick one to remove.
# Deletes both the shell alias line and the corresponding Raycast script.
function remove_entry() {
  if [[ ! -f "$NAV_FILE" ]]; then
    echo "Nothing to remove."
    exit 0
  fi

  mapfile -t lines < <(grep '^alias ' "$NAV_FILE")

  if [[ ${#lines[@]} -eq 0 ]]; then
    echo "Nothing to remove."
    exit 0
  fi

  echo "Select alias to remove:"
  for i in "${!lines[@]}"; do
    local name=$(extract_alias_name "${lines[$i]}")
    local repo=$(extract_repo_name "${lines[$i]}")
    echo "  $((i + 1))) $name -> $repo"
  done

  read -p "Enter number: " idx
  idx=$((idx - 1))

  local target_line="${lines[$idx]}"
  local name=$(extract_alias_name "$target_line")

  grep -vF "$target_line" "$NAV_FILE" >"$NAV_FILE.tmp" && mv "$NAV_FILE.tmp" "$NAV_FILE"

  local script_path="$RAYCAST_DIR/$name.sh"
  [[ -f "$script_path" ]] && rm "$script_path"

  echo "Removed: $name"
}

# Entry point
case "$1" in
  remove)
    remove_entry
    ;;
  *)
    if [[ -n "$1" && -n "$2" && -n "$3" ]]; then
      add_entry "$1" "$2" "$3"
    else
      interactive_add
    fi
    ;;
esac
