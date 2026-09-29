# --------------------------------------------------
# Author  : Peng-Yu Chen
# Email   : me@pengyuc.com
# Updated : 09/28/2026
# Path    : $HOME/.config/zsh/init/functions/git.sh
# --------------------------------------------------

function gri() {
  git rebase -i HEAD~"$1"
}

function gfr() {
  git fetch origin $1 && git reset --hard origin/$1
}

function gf() {
  gfr main
}

# Run `gfr` in every repo under ~/Repos, in parallel.
#   gfra           reset each repo's current branch to origin/<current branch>
#   gfra main      only touch repos currently on `main`
#   gfra -f [br]   also reset dirty / diverged repos and repos on another branch
function gfra() {
  setopt local_options no_monitor no_notify
  local force=0
  if [[ "$1" == "-f" ]]; then
    force=1
    shift
  fi

  local repo
  for repo in $HOME/Repos/*(/); do
    [[ -e "$repo/.git" ]] || continue
    (
      cd "$repo"
      local name="${repo:t}"
      local current="$(git branch --show-current)"
      local branch="${1:-$current}"

      if ! git remote get-url origin &>/dev/null; then
        print -P "%F{8}- $name: no origin%f"
      elif (( ! force )) && [[ "$current" != "$branch" ]]; then
        print -P "%F{yellow}- $name: on '$current', not '$branch'%f"
      elif (( ! force )) && [[ -n "$(git status --porcelain --untracked-files=no)" ]]; then
        print -P "%F{yellow}- $name: uncommitted changes%f"
      elif ! out="$(git fetch -q origin "$branch" 2>&1)"; then
        print -P "%F{red}✗ $name: ${out//\%/%%}%f"
      elif (( ! force )) && (( $(git rev-list --count "origin/$branch..HEAD") > 0 )); then
        print -P "%F{yellow}- $name: has unpushed commits%f"
      else
        git reset -q --hard "origin/$branch"
        print -P "%F{green}✓ $name%f ($branch @ $(git rev-parse --short HEAD))"
      fi
    ) &
  done
  wait
}
