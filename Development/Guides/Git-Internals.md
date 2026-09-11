# Git Internals Notes

Standalone note. No links in or out.

## Object Model

- blob: file content, addressed by hash.
- tree: directory snapshot listing blobs and subtrees.
- commit: tree plus parents plus author plus message.
- tag: named pointer to a commit, annotated tags are objects too.

## Refs and HEAD

```bash
git cat-file -p HEAD
git rev-parse HEAD
git show-ref
```

- Branches are movable pointers, HEAD points at the current one.
- Detached HEAD means HEAD points at a commit directly.

## Plumbing Peeks

```bash
git hash-object file.txt
git ls-tree HEAD
git log --graph --oneline --all
git fsck --lost-found
```

## Packfiles

- Loose objects compress into packs on gc or push.
- Deltas store similar blobs as diffs against a base.
- `git gc` and `git repack -Ad` rebuild packs manually.

## Gotchas

- Rewriting public history breaks everyone else, revert instead.
- Stash entries live in reflog, recoverable for about 90 days default.
- `git clean -fdx` deletes ignored files too, preview with `-n` first.
- Line endings via .gitattributes, not hope.

Tags: #git #internals #programming
