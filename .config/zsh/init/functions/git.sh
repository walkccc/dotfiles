# --------------------------------------------------
# Author  : Peng-Yu Chen
# Email   : me@pengyuc.com
# Updated : 04/20/2026
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
