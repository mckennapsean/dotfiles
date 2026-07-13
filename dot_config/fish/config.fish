if status is-interactive
    # Commands to run in interactive sessions can go here
end
abbr -a -- g git
abbr -a -- b lucid-bazel
abbr -a -- cx codex
abbr -a -- lm 'cd ~/lucid/main/'
abbr -a -- lm1 'jjw ~/lucid/main-01/'
abbr -a -- lm2 'jjw ~/lucid/main-02/'
abbr -a -- lm3 'jjw ~/lucid/main-03/'
abbr -a --set-cursor='%' -- jjf 'shed format --since=$(jj log -r "@-%" --no-graph -T commit_id --limit 1)'
abbr -a -- pkk 'pkill -9 -f'
abbr -a -- cpu 'watch grep \"cpu MHz\" /proc/cpuinfo'
abbr -a -- cf 'rg --files | fzf -m | xargs -d "\n" code'

# switch & update workspace if needed
function jjw
    cd $argv[1]
    jj 2>/dev/null
    or begin
        jj workspace update-stale
        and jj
    end
end

# jj dynamic completions
if command -v jj >/dev/null
    COMPLETE=fish jj | source
end

# pnpm
set -gx PNPM_HOME "/home/seanm/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

direnv hook fish | source
set -Ux DIRENV_LOG_FORMAT ""
