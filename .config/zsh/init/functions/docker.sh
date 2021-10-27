# --------------------------------------------------
# Author  : Peng-Yu Chen
# Email   : me@pengyuc.com
# Updated : 04/20/2026
# Path    : $HOME/.config/zsh/init/functions/docker.sh
# --------------------------------------------------

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
