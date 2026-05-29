# --------------------------------------------------
# Author  : Peng-Yu Chen
# Email   : me@pengyuc.com
# Updated : 04/20/2026
# Path    : $HOME/.config/zsh/init/functions/agent.sh
# --------------------------------------------------

function _random_color() {
  local -a colors=(red orange yellow green blue purple pink)
  echo "${colors[$(( RANDOM % ${#colors[@]} + 1 ))]}"
}

function wsc() {
  local branch="$1"

  if [[ -z "$branch" ]]; then
    echo "Usage: wsc <branch-name>"
    return 1
  fi

  local color
  color="$(_random_color 2>/dev/null || echo "yellow")"

  local cmd
  cmd="claude -n '{{ branch }}' '/color $color'"

  if git show-ref --verify --quiet "refs/heads/$branch"; then
    echo "→ Switching to existing branch: $branch"
    wt switch "$branch" -x sh -- -c "$cmd"
  else
    echo "→ Creating and switching to new branch: $branch"
    wt switch --create "$branch" -x sh -- -c "$cmd"
  fi
}
