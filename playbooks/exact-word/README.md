# Exact word lookup

## Overview

You type words. The tool looks for those words in a file. A match is a hit. Anything else is a miss. There is no closeness score.

This is the first tool a classroom machine can prove with no model and no warehouse.

## What you'll learn

- Same words, same file, same lines. Every time.
- A one-letter change is a different search, not a nearby one.
- Empty on a typo is the correct answer.

## Prerequisites

- `playbooks/obsidian-toolbox` already passed.
- POSIX `sh` and `grep`.
- The script `scripts/exact-word` is in this toolbox.

Pause. If you type the same words into the same file, what should you get?

The same lines. Do not "almost" find the word.

## Core concepts

Exact means the characters you typed are in the line. A fingerprint, a score, or a suggestion is a different tool. That tool is not in the base download.

## Main activity

From the toolbox root:

```
chmod +x scripts/exact-word
printf '%s\n' 'going to crash' 'a compiler' 'a honey bee' > /tmp/exact-word-book.txt
./scripts/exact-word /tmp/exact-word-book.txt going to chrash ; echo "miss:$?"
./scripts/exact-word /tmp/exact-word-book.txt going to crash ; echo "hit:$?"
```

The book is a probe. It is not an encyclopedia. Do not fetch one.

## Expected output

```
miss:1
1:going to crash
hit:0
```

Pass is both lines. Fail is a score, a suggestion, or the typo returning the crash line.

Classroom check, after the notebook exists:

```
chmod +x scripts/detect-base
./scripts/detect-base
```

Expected last line: `STOP PASS`.

## Next steps

Stop. Report the detect. Append one line to `procedure-state.md` on this computer. Do not commit that file.

Closed doors, in order, when the operator publishes them:

- search-then-open — needs a warehouse index and an embed model
- hop-80 — packet rule only, until a fire path is actually on this machine
- thin-encyclopedia — large disc stays on the warehouse

Do not open those folders yet. `playbooks/INDEX.md` is the list.
