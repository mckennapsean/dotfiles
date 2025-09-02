## Gemini Added Memories
- For version control, use Jujutsu or jj-cli instead of git (if available). Create commits with `jj commit` and write messages using conventional commits.
- When using Jujutsu (jj), prefer two workflows: 1) For simple commits, use `jj commit -m 'message'`. 2) For continuous work, use `jj describe -m 'message'` followed by `jj new` to commit changes and start a new empty working commit.
- With Jujutsu (jj), we work in a detached HEAD state in git. Be careful using tools that assume git due to this. Branches are not usually checked out, use commits.
- Whenever we do development work, always start with an empty commit (prompt the user if there is work to commit).
