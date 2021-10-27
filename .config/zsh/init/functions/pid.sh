# --------------------------------------------------
# Author  : Peng-Yu Chen
# Email   : me@pengyuc.com
# Updated : 04/20/2026
# Path    : $HOME/.config/zsh/init/functions/pid.sh
# --------------------------------------------------

function pid() {
  echo $(lsof -t -i:"$1")
}

function kpid() {
  pid=$(lsof -t -i:"$1")
  echo "the killed pid: $pid"
  kill -9 $pid
}
