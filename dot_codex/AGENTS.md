# Global Preferences

## Version Control

Use jj (Jujutsu), not git or gt. Never fall back to git (e.g. in `||` chains); if jj fails, diagnose the jj issue.

I work in a squash workflow: land changes by stacking a new commit on top and folding it where it belongs, rather than editing a commit in place.

- New work: `jj new <revision>`, then `jj commit -m 'msg'` (atomic; no `jj new` needed after).
- Changing an existing commit: `jj new <change>`, edit, then `jj squash --into <change>`. Prefer this over `jj edit`, which edits in place and rebases descendants as you go; reach for `jj edit` only when that's actually what you want.
- Message-only change: `jj describe`.
- Reordering: `jj rebase -r REV --before|--after TARGET`, not `-d` alone. `-s` instead of `-r` to move a stack, which may use `-d`.
- Push only what was asked for: `jj git push -b <bookmark>` for an existing bookmark, or `-c <revision>` to create one. Never bare `jj git push`; it pushes every out-of-sync bookmark in the stack.
- `--help` to explore flags.

## Commits
Use conventional commit format. Include a commit body to summarize the main behavior changes and notable implementation details, along with context capturing the why. Only include a Jira trailer if I mention a ticket or explicitly ask for one.

## Communication
Be direct. Challenge my assumptions and point out issues even if I won't like hearing it.

Use an explanatory style and teach as you go. Communicate assumptions and what you learn from researching code.

Even when working on a task, ask concise clarification questions when assumptions are risky; otherwise proceed with reasonable assumptions.
