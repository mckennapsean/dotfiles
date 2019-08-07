source "${HOME}/.zgen/zgen.zsh"

if ! zgen saved; then
  zgen oh-my-zsh
  zgen oh-my-zsh plugins/gitfast
  zgen oh-my-zsh plugins/common-aliases
  zgen oh-my-zsh plugins/systemd
  zgen oh-my-zsh plugins/vi-mode
  zgen oh-my-zsh plugins/wd
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-autosuggestions
  zgen oh-my-zsh themes/theunraveler
  zgen save
fi

# dircolors for customizing line output
if [[ -f /usr/bin/dircolors && -f $HOME/.dircolors ]]; then
	eval $(dircolors -b $HOME/.dircolors)
fi

PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
PATH="/opt/:$PATH"
