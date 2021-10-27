# load all files in ~$HOME/.config/zsh/init
for file in $HOME/.config/zsh/init/**/*.zshrc
do
  source "$file"
done
