# --------------------------------------------------
# Author  : Peng-Yu Chen
# Email   : me@pengyuc.com
# Updated : 05/19/2025
# Path    : $HOME/.config/zsh/init/functions.sh
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

function lf() {
  mkdir -p /tmp/lf
  cd /tmp/lf
  cp /tmp/_env /tmp/lf/.env
  conda create --name lf python=3.12 --yes
  conda activate lf
  curl -H "Authorization: token $GITHUB_TOKEN" https://raw.githubusercontent.com/walkccc/LeetFlow/main/requirements.txt -o requirements.txt
  python3 -m pip install -r requirements.txt
  bash <(curl -H "Authorization: token $GITHUB_TOKEN" https://raw.githubusercontent.com/walkccc/LeetFlow/main/mock.sh)
}

function unlf() {
  conda deactivate
  rm -rf /tmp/lf
  echo y | conda env remove --name lf
}

function pid() {
  echo $(lsof -t -i:"$1")
}

function kpid() {
  pid=$(lsof -t -i:"$1")
  echo "the killed pid: $pid"
  kill -9 $pid
}

function docker_reset_all() {
  docker stop $(docker ps -q)
  docker rm $(docker ps -a -q)
  docker rmi $(docker images -a -q)
  docker volume rm $(docker volume ls -q)
}

function docker_reset_ps() {
  docker stop $(docker ps -q)
  docker rm $(docker ps -a -q)
}
