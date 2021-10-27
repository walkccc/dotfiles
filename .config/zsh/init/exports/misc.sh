# --------------------------------------------------
# Author  : Peng-Yu Chen
# Email   : me@pengyuc.com
# Updated : 04/20/2026
# Path    : $HOME/.config/zsh/init/exports/misc.sh
# --------------------------------------------------

# Docker
export DOCKER_CONFIG=$HOME/.config/docker

# Go
export GOPATH=$HOME/.config/go
export GOROOT=$(brew --prefix golang)/libexec
export PATH=$PATH:${GOPATH}/bin:${GOROOT}/bin

# XDG
export PATH=$HOME/.local/bin:$PATH
export PATH=/Library/Frameworks/Mono.framework/Versions/6.12.0/Commands:$PATH
