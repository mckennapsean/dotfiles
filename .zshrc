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
PATH="${HOME}/.bin:/opt/:$PATH"
PATH="${HOME}/.local/bin/:$PATH"
PATH="${HOME}/.npm/bin/:$PATH"

# auto-complete for git alias
_git_behind_master ()
{
  _git_rebase
}
GIT_COMPLETION_CHECKOUT_NO_GUESS=1

alias cpu='watch grep \"cpu MHz\" /proc/cpuinfo'
alias pkk='pkill -9 -f'
alias gitmain='git remote show origin | grep "HEAD branch" | cut -d" " -f5'
alias g='git'

# load work config
if [[ $(hostname) == *"lucid"* ]]; then
  . ~/.zshrc.lucid
fi
