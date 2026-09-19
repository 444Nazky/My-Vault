# Git Branch Workflow Quick Ref

> Standalone reference. No links in or out. Embed-only.

```mermaid
graph LR
    A[Working Dir] --> B[Staging]
    B --> C[Local Repo]
    C --> D[Remote]
```

## Flow

1. Edit files in working dir
2. `git add` to stage changes
3. `git commit` to snapshot into local repo
4. `git push` syncs to remote
5. `git pull` fetches others' changes

## Diagram

![[git-workflow.svg]]

Keep commits small. One logical change per commit, write messages that explain why.

## Tag Line

Tags: #git #github #development