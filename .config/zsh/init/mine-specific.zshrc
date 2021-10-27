export REPOS=$HOME/Repos

# Open by Neovim
alias clrs="v $REPOS/CLRS"
alias lc="v $REPOS/LeetCode"

# Open by VSC
alias vlc="code $REPOS/LeetCode"

# Change directory
alias clc="cd $REPOS/LeetCode/solutions"

# Python
alias pw="python ~/Repos/scripts/walk.py"
alias pre="python ~/Repos/re/cpp2python.py"

# Miscellaneous
alias lc_mock="conda activate leetcode; git clone -b scripts --single-branch git@github.com:walkccc/LeetCode.git ~/Desktop/scripts; cd ~/Desktop/scripts; cp ~/Downloads/.env.uu ./.env; bash mock.sh"
