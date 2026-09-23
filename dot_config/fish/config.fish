# switch & update workspace if needed
function jjws
    cd $argv[1]
    jj 2>/dev/null
    or begin
        jj workspace update-stale
        and jj
    end
end

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

if status is-interactive
    abbr -a -- g git
    abbr -a -- b lucid-bazel
    abbr -a -- cx codex
    abbr -a -- lm 'cd ~/lucid/main/'
    abbr -a -- lm1 'jjws ~/lucid/main-01/'
    abbr -a -- lm2 'jjws ~/lucid/main-02/'
    abbr -a -- lm3 'jjws ~/lucid/main-03/'
    abbr -a --set-cursor='%' -- jjf 'shed format --since=$(jj log -r "@-%" --no-graph -T commit_id --limit 1)'
    abbr -a -- pkk 'pkill -9 -f'

    if type -q direnv
        set -gx DIRENV_LOG_FORMAT ""
        direnv hook fish | source
    end
end
