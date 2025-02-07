if status is-interactive
    # Commands to run in interactive sessions can go here
end
abbr -a -- g git
abbr -a -- b lucid-bazel
abbr -a -- lm 'cd ~/lucid/main/'
abbr -a -- bfd 'lucid-bazel format --diff'
abbr -a --set-cursor='%' -- bfs 'bazel format --diff --since=%'
abbr -a -- check 'git check && jj git fetch --branch  master --branch master-stable && echo "Git fetched from upstream." && git check'
abbr -a -- cpr 'shed bitbucket create-pr-link'
abbr -a -- csd 'shed bitbucket create-pr-link --target $(git log --pretty=format:%D | grep -m1 "^origin/" | cut -d, -f1 | sed "s/^origin\///")'
abbr -a -- pkk 'pkill -9 -f'
abbr -a -- cpu 'watch grep \"cpu MHz\" /proc/cpuinfo'
