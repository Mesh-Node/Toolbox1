# Quick start

This file is not the bootstrap. Read `BASE.md`, then `playbooks/INDEX.md`. Run published base playbooks only.

The old one-file walk is retired. Do not follow the steps below.

This computer is the host. You are the agent. Together: a smart node. You bring the model.

A toolbox is notes on disk plus one tool you can run. You build it here. You do not copy another computer's home.

If it is not written here, it is not a step.

## Basic toolset

One tool. Exact word lookup.

You type words. The tool looks for those words in a file you wrote. A match is a hit. Anything else is a miss. There is no closeness score. A one-letter change is a different search.

Pause. If you type the same words into the same file, what should you get?

The same lines. Every time. Empty on a typo is the correct answer. Do not "almost" find the word.

Lesson, if a browser is open: `lessons/lesson-exact-lookup.html`. The pause above is the lesson if it is not.

## 0. Seed

The seed folder is on this computer, or `lan-probe` from that seed already ran.

If the seed is missing, stop. Return to Mesh-Node/mesh-node. Do not skip.

Detect: a house name, a host path, or a costume inside the seed. Wrong layer. Stop.

## 1. Folder you own

Work inside this folder. Do not write into another user's home.

```
mkdir -p notebook/tools
```

## 2. The note

Write `notebook/tools/exact-word.md` with this text:

```
# Exact word lookup

Hit or miss. No fingerprint.

Same words, same file, same lines.
A typo is a miss. Empty is correct.
```

## 3. The book

Write `book.txt` in this folder:

```
going to crash
a compiler
a honey bee
```

This file is a probe. It is not an encyclopedia. Do not fetch one.

## 4. The tool

Write `exact-word` in this folder:

```
#!/bin/sh
# exact-word BOOK WORDS...
# Hit: print matching lines, exit 0. Miss: print nothing, exit 1.
set -eu
book=$1
shift
[ -f "$book" ] || { echo "no book" >&2; exit 2; }
q=$(printf '%s' "$*")
if grep -F -n -e "$q" "$book"; then
  exit 0
fi
exit 1
```

Then:

```
chmod +x exact-word
```

## 5. Detect

```
./exact-word book.txt going to chrash ; echo "miss:$?"
./exact-word book.txt going to crash ; echo "hit:$?"
```

Pass: the first command prints no line and `miss:1`. The second prints the crash line and `hit:0`.

Fail: a score, a suggestion, or the typo returning the crash line. The tool guessed. Delete it and write it again from step 4. Do not add a closeness score.

## 6. State

Append one line per step to `procedure-state.md` on this computer. Do not commit that file.

```
STEP <n> PASS|FAIL <one fact>
```

## 7. Stop

Report the two detect lines. Stop.

Do not expand. Do not open hop, search, an encyclopedia disc, peer memory, or a persona file. Those are later, after the operator reads your detect and says expand.

Do not push. Do not watch GitHub.
