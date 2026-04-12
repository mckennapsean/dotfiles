if status is-interactive
    # Commands to run in interactive sessions can go here
end
abbr -a -- g git
abbr -a -- b lucid-bazel
abbr -a -- lm 'cd ~/lucid/main/'
abbr -a -- lm1 'jjw ~/lucid/main-01/'
abbr -a -- lm2 'jjw ~/lucid/main-02/'
abbr -a -- lm3 'jjw ~/lucid/main-03/'
abbr -a -- bfd 'lucid-bazel format --diff'
abbr -a --set-cursor='%' -- bfs 'bazel format --diff --since=%'
abbr -a -- check 'git check && jj git fetch --branch  master --branch master-stable && echo "Git fetched from upstream." && git check'
abbr -a -- cpr 'shed bitbucket create-pr-link'
abbr -a -- csd 'shed bitbucket create-pr-link --target $(git log --pretty=format:%D | grep -m1 "^origin/" | cut -d, -f1 | sed "s/^origin\///")'
abbr -a -- pkk 'pkill -9 -f'
abbr -a -- cpu 'watch grep \"cpu MHz\" /proc/cpuinfo'

# switch & update workspace if needed
function jjw
    cd $argv[1]
    jj 2>/dev/null
    or begin
        jj workspace update-stale
        and jj
    end
end

# pnpm
set -gx PNPM_HOME "/home/seanm/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
