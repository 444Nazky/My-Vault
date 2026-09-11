# GitHub Cheatsheet

**Location:** vault root
**See also:** Development/Github/GitHub - Connect Repository Tutorial for first-time repo setup

## First-Time Setup

```bash
git config --global user.name "nazky"
git config --global user.email "you@mail.com"
git config --global init.defaultBranch main
gh auth login
```

## Start or Clone

```bash
git init
git clone git@github.com:user/repo.git
git clone https://github.com/user/repo.git
```

## Daily Loop

```bash
git status -sb
git add -p
git commit -m "short imperative message"
git push
git pull --rebase
```

## Branches

```bash
git branch feature-x
git switch feature-x
git switch -c feature-x
git branch -d feature-x
git push -u origin feature-x
```

## Merge vs Rebase

```bash
git merge main              # keeps history, adds merge commit
git rebase main             # linear history, rewrites commits
git rebase --abort          # bail out of a bad rebase
```

## Stash

```bash
git stash push -m "wip"
git stash list
git stash pop
```

## Undo

```bash
git restore file.txt        # discard unstaged changes
git restore --staged file.txt
git commit --amend --no-edit
git reset --soft HEAD~1     # keep changes, undo commit
git reset --hard HEAD~1     # destroy changes, careful
git revert <sha>            # safe undo on shared branches
```

## Remotes

```bash
git remote -v
git remote add origin git@github.com:user/repo.git
git fetch --prune
```

## Pull Requests with gh

```bash
gh pr create --fill
gh pr status
gh pr checkout 123
gh pr merge 123 --squash
gh issue list
```

## Tags and Releases

```bash
git tag v1.0.0
git push origin v1.0.0
gh release create v1.0.0 --generate-notes
```

## History and Blame

```bash
git log --oneline -10
git log -p -- file.txt
git blame -L 10,20 file.txt
git show <sha>
```

## Ignore and Clean

```bash
echo "*.log" >> .gitignore
git rm --cached secrets.env
git clean -nd                  # preview, then -f to delete
```

## Gotchas

- Pull with rebase on shared branches, merge locally when history matters.
- Never force-push shared branches, use revert instead.
- Commit small and often, push at logical checkpoints.
- Keep secrets out of history, rotate any that leak.


