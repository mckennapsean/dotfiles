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

alias ergodox='feh --bg-max ~/Pictures/Ergodox/ergodox.png'

# work aliases
alias lsf='lucid-start fast'
alias lsfe='lucid-start sh --frontend'
alias lsbe='lucid-start sh --s3_assets'
alias lss='lucid-start sh -D --no-watch'
alias lbb='lucid-bazel build'
alias lbf='lucid-bazel format'
alias lbff='lucid-bazel format --diff'
lbfd() {lucid-bazel format --diff --since=$1}
alias lbr='lucid-bazel run'
alias lbt='lucid-bazel test'
alias lbq='lucid-bazel query'
alias scalats='lucid-bazel build $(lucid-bazel query generatets)'
alias compat='bazel build $(bazel query "filter(compat_test, //src/jvm/...)") --keep_going || tools/bazel-fix-deps.py'
lbbd() {bazel build $(bazel query "same_pkg_direct_rdeps(set($(git diff --name-only $1)))")}
alias tb='shed trigger-build'
alias gpab='g psf;tb'
alias lblc='export BAZEL_CACHE=none'
alias lbrc='unset BAZEL_CACHE'
alias lde='python3 ~/lucid/main/cake/app/lucidchart-tools/document-state-extractor/extract-document-state.py'
alias check='git check && git fetch && echo "Git fetched from upstream." && git check'
alias gcalf='git commit --amend --author="Lucid Format <ops@lucidchart.com>"'
alias ldt='~/lucid/main/scripts/list-deploy-targets.sh'
alias lir='lucid-is-released -e production'
lbv() { lucido version --commit=$1 bazel:cake-build:cake-bazel:tgz }
alias lll='~/lucid/l3/l3.sh'
alias lco='lll checkout'

# Usage: set-main ~/lucid/main
set-main() {
    sudo rm -f /var/lucid/main && sudo ln -s "$(readlink -f ${1})" /var/lucid/main
};

# work-specfic config
export BAZEL_COMPLETION_USE_QUERY=true
NOW=$(date +%s)
LAST_RUN=$(sudo cat /var/cache/chef/lastrun)
if (( LAST_RUN + 120*60 < NOW )); then
    echo "WARNING: Chef not run for more than 120 minutes."
. /home/seanm/.asdf/asdf.sh
