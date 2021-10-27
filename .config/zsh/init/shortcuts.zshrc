# Shorter command
alias cls="clear"
alias g="git"
alias v="nvim"

# General
alias la="ls -la"
alias sz="source $HOME/.config/zsh/.zshrc"

# Open by Neovim
alias vzsh="v $HOME/.config/zsh/init"
alias vlua="v $HOME/.config/nvim/lua"

# Change directory
alias h="cd $HOME"
alias cnv="cd $HOME/.config/nvim"
alias clua="cd $HOME/.config/nvim/lua"
alias dsk="cd $HOME/Desktop"

function pid() {
  echo $(lsof -t -i:"$1")
}
