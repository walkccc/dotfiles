alias ga="git add . && git commit -m '\$\$\$'"
alias gf="git fetch --all && git reset --hard origin/main"

function acp() {
  git add .
  git commit -m 'Checkpoint'
  git push -f
}

function gri() {
  git rebase -i HEAD~"$1"
}

function pid() {
  echo $(lsof -t -i:"$1")
}
