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

alias cpu='watch grep \"cpu MHz\" /proc/cpuinfo'
alias pkk='pkill -9 -f'
alias gitmain='git remote show origin | grep "HEAD branch" | cut -d" " -f5'

alias g='git'
alias ergodox='feh --bg-max ~/Pictures/Ergodox/ergodox.png'


# work aliases
alias lsf='lucid-start --frontend'
alias lss='lucid-start'
alias lbb='lucid-bazel build'
alias lbf='lucid-bazel format'
alias lbff='lucid-bazel format-fast'
alias lbr='lucid-bazel run'
alias lbt='lucid-bazel test'
alias lbq='lucid-bazel query'
alias lde='python3 ~/lucid/main/cake/app/lucidchart-tools/document-state-extractor/extract-document-state.py'
alias check='git check && git fetch && echo "Git fetched from upstream." && git check'
alias gcalf='git commit --amend --author="Lucid Format <ops@lucidchart.com>"'
alias ldt='~/lucid/main/scripts/list-deploy-targets.sh'
alias lir='lucid-is-released -e production'
lbv() { lucido version --commit=$1 bazel:cake-build:cake-bazel:tgz }

# work-specfic config
export BAZEL_COMPLETION_USE_QUERY=true
NOW=$(date +%s)
LAST_RUN=$(sudo cat /var/cache/chef/lastrun)
if (( LAST_RUN + 30*60 < NOW )); then
    echo "WARNING: Chef not run for more than 30 minutes."
fi
cd ~/lucid/main/
