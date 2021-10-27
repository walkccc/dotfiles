# --------------------------------------------------
# Author  : Peng-Yu Chen
# Email   : me@pengyuc.com
# Updated : 04/20/2026
# Path    : $HOME/.config/zsh/init/functions/leetcode.sh
# --------------------------------------------------

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
