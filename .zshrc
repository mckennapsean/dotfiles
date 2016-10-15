source "${HOME}/.zgen/zgen.zsh"

if ! zgen saved; then
  zgen oh-my-zsh
  zgen oh-my-zsh plugins/gitfast
  zgen oh-my-zsh plugins/common-aliases
  zgen oh-my-zsh plugins/systemd
  zgen oh-my-zsh plugins/vi-mode
  zgen oh-my-zsh plugins/wd
  zgen load zsh-users/zsh-syntax-highlighting
  zgen oh-my-zsh themes/theunraveler
  zgen save
fi

PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
