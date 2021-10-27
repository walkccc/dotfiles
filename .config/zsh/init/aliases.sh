# --------------------------------------------------
# Author  : Peng-Yu Chen
# Email   : me@pengyuc.com
# Updated : 05/19/2025
# Path    : $HOME/.config/zsh/init/aliases.sh
# --------------------------------------------------

# Environment Variables
export DOCKER_CONFIG=$HOME/.config/docker
export REPOS=$HOME/Repos

# PATH Configuration
export PATH="/Users/Jay/.local/bin:$PATH"
export PATH="$PATH:~/go/bin"

# LunarVim and Cursor Shortcuts
alias v="lvim"
alias c="cursor"
alias vzsh="v $HOME/.config/zsh/init"

# Python Script Aliases
alias ld="python3 ~/Repos/scripts/leetdash.py"
alias lw="python3 ~/Repos/scripts/leetwalk.py"

# Git and Miscellaneous Aliases
alias g="git"
alias ga="git add . && git commit -m 'git'"
alias gre="git reflog expire --expire-unreachable=now --all"

# Directory Navigation
alias h="cd $HOME"
alias rp="cd $HOME/Repos"
alias nt="cd $HOME/Repos/nextjs"
alias cpk="cd $HOME/Repos/nextjs/pokemontcgp"
alias clc="cd $REPOS/LeetCode"

# System Utilities
alias la="ls -la"
alias sz="source $HOME/.config/zsh/.zshrc"
