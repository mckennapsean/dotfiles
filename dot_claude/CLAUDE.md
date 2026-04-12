# Global Preferences

## Version Control
Use jj (Jujutsu), not git or gt, for all version control operations.
Never use git as a fallback (e.g. in `||` chains) — if jj fails, diagnose the jj issue.

- Use `jj commit -m "msg"` to finalize work (atomic — creates a new empty working copy, no `jj new` needed after)
- Use `jj squash` when folding working-copy changes into the parent (e.g., build/format fixes that belong with the prior commit) — don't use it as a substitute for `jj commit` when creating standalone work
- Use `jj describe` only to update an existing revision's commit message
- Use `jj new <change-id>` to start work on top of a commit, not `jj edit` or `jj rebase`
- Use `jj rebase -r REV --before TARGET` (or `--after`) for reordering commits in a stack — not `-d` alone
- Push: `jj git push -c @-` creates a bookmark from the last revision and pushes; chain multiple `-c` flags for multiple revisions
- Use `--help` to explore flags when needed

## Commits
Use conventional commit format. Only include a Jira trailer if I mention a ticket or explicitly ask for one.

## Communication
Be direct. Challenge my assumptions and point out issues even if I won't like hearing it.

Ask questions using the AskUserQuestion tool to clarify assumptions and expand understanding, even while actively working on a task.
