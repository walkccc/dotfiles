# Environment Variables
export VAGRANT_HOME=$HOME/.local/share/vagrant
export DOCKER_CONFIG=$HOME/.config/docker
export WORKSPACE=$HOME/.cache/java-workspace # jdtls's workspace dir of nvim-lspconfig
export REPOS=$HOME/Repos

# Java Version Management
export JAVA_11_HOME=$(/usr/libexec/java_home -v11)
export JAVA_13_HOME=$(/usr/libexec/java_home -v13)
export JAVA_15_HOME=$(/usr/libexec/java_home -v15)
alias java11='export JAVA_HOME=$JAVA_11_HOME'
alias java13='export JAVA_HOME=$JAVA_13_HOME'
alias java15='export JAVA_HOME=$JAVA_15_HOME'
java11 # default to Java 11

# PATH Configuration
export PATH="/Users/Jay/.local/bin:$PATH"
export PATH="$PATH:~/go/bin"

# LunarVim and Visual Studio Code Shortcuts
alias v="lvim"
alias clrs="v $REPOS/CLRS"
alias lc="v $REPOS/LeetCode"
alias vlc="code $REPOS/LeetCode"
alias clc="cd $REPOS/LeetCode"
alias vzsh="v $HOME/.config/zsh/init"

# Python Script Aliases
alias ld="python3 ~/Repos/scripts/leetcode_dashboard.py"
alias pw="python3 ~/Repos/scripts/walk.py"
alias topy="python3 ~/Repos/scripts/cpp2python/cpp2python.py"
alias tojava="python3 ~/Repos/scripts/cpp2java/cpp2java.py"

# Git and Miscellaneous Aliases
alias ga="git add . && git commit -m 'git'"
alias g="git"
alias gre="git reflog expire --expire-unreachable=now --all"
alias deploy_portfolio="cd $REPOS/portfolio && g co gh-pages && cp dist/* . && ga && g pf"

# Directory Navigation
alias h="cd $HOME"
alias rp="cd $HOME/Repos"

# System Utilities
alias la="ls -la"
alias sz="source $HOME/.config/zsh/.zshrc"

function gri() {
  git rebase -i HEAD~"$1"
}

function gfr() {
  git fetch origin $1 && git reset --hard origin/$1
}

function lcmock() {
  mkdir -p /tmp/lcmock
  cd /tmp/lcmock
  cp /tmp/_env /tmp/lcmock/.env
  conda create --name lcmock python=3.11 --yes
  conda activate lcmock
  curl -s https://raw.githubusercontent.com/walkccc/LeetCode/scripts/requirements.txt -o requirements.txt
  python3 -m pip install -r requirements.txt
  bash <(curl -s https://raw.githubusercontent.com/walkccc/LeetCode/scripts/mock.sh)
}

function delete_lcmock() {
  conda deactivate
  rm -rf /tmp/lcmock
  conda env remove --name lcmock
}

function lcc() {
  gh repo edit walkccc/LeetCode --default-branch gh-pages &&
    gh repo edit walkccc/LeetCode --default-branch main &&
    bash ~/Repos/scripts/dwr.sh walkccc/LeetCode &&
    clc && gfr main
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

