# Stand up a base node

Reading this page does not install anything. Discovery, approval, and a passed detect are three steps. Do not run a command in Procedure until the operator says go.

## Overview

A base node is a host plus an agent plus this toolbox. You bring the model. This playbook installs the small dependencies, opens an Obsidian notebook, and proves three tools that already work: a hop packet, a word search, and a local encyclopedia disc.

The notebook is the toolbox. A new tool is a note, a script, and a detect. The three tools below are the examples. Copy that shape. Do not copy another home.

## What you'll learn

- Confirm this host is Omarchy before you install. Omarchy is the OS layer. A hostname is not the proof.
- Install only the packages this page names.
- Open the notebook. The files are the pass. The app is optional.
- Add a tool: note, script, detect, link.
- Hop-80 keeps the old session uncompressed. A short packet starts the next one.
- Search is two lists. Do not fuse them. Do not ask the chat model.
- A local disc returns titles. The large English disc does not travel.

## Requirements

Already done: Mesh-Node/mesh-node said Stop.

This page assumes Omarchy. Omarchy is a configuration layer on Arch Linux: Arch packages, Hyprland, and the `omarchy-*` commands. It is not a machine name. Prove that in step 1 before any install.

Packages, after go, and only after step 1 passes:

```
sudo pacman -S --needed obsidian kiwix-tools libzim jq sqlite python
```

If the detect in step 1 fails, stop. Do not invent package names for another OS.

`hermes` on PATH, or stop and tell the operator. Do not pipe a remote install script.

Disk for the two data files, only if the operator places them: about 1 GB. RAM stays small. Do not load a large chat model on a small host.

## Authority

This page reads. It does not send. It does not read another user's home.

After go, package install changes the system packages.

After a second go, you may place two files:

```
data/knowledge.sqlite
data/simple.zim
```

You do not fetch the large English disc. You do not copy a home directory, a secret, a model weight, or a peer-memory database.

`scripts/hop-scope` builds a packet. It does not close a window. The desktop send script does not travel.

`scripts/search-open` reads the sqlite. It does not embed. It does not call a chat model.

`scripts/zim-search` reads the simple disc and prints titles.

## Core concepts

Files stay on disk. A packet names them. The new session does not get the old chat.

Compression stays off. Near 80% full, a hop may start a new session. That is not a summary. A slogan such as `Continue.` is not a goal.

Word search and meaning search are two lists. A mixed number is a fail.

The encyclopedia is a file on this computer. First list is titles. Empty on a typo is correct for exact lookup. A high score on the wrong title is still wrong.

A tool is not in the toolbox until Index links it and a detect has a pass and a fail.

## Procedure

From the toolbox root. Stop on the first fail.

### 1. Omarchy

Purpose: the packages and the desktop tools on this page are native to Omarchy. Native means they use Arch's pacman, Omarchy's package set, and, when a tool talks to the screen, Hyprland. It does not mean every script is an `omarchy` subcommand.

Omarchy is a configuration layer on Arch Linux. The proof is the OS id. A hostname that says omarchy is not the proof.

Location: any directory. This step writes nothing.

```
. /etc/os-release
printf '%s %s %s\n' "$ID" "$ID_LIKE" "$VERSION_ID"
omarchy-version
omarchy-version-channel
```

Check: the first line starts with `omarchy` and includes `arch`. `omarchy-version` prints a version. The channel is `stable`, `rc`, `edge`, or `dev`.

On one Omarchy host this printed `omarchy arch 4.0.0`, version `4.0.0-1`, channel `stable`. That stamp is not the MSI. Record what this host prints.

Failure: `$ID` is not `omarchy`, or `omarchy-version` is missing. Stop. Report the id. Do not continue to package install.

The hop packet script does not need Hyprland. A script that closes a window does. That script is not in this download. Search and the disc use Arch packages. They are not `omarchy` subcommands.

### 2. Notebook

```
chmod +x scripts/bootstrap-vault scripts/exact-word scripts/hop-scope scripts/search-open scripts/zim-search
./scripts/bootstrap-vault
```

Open `notebook/Index.md`. It links seed and exact-word. If Obsidian is installed, open this folder as a vault. If not, read the markdown.

### 3. How to create a tool

Exact word lookup is the pattern. Same words, same file, same lines. A typo is a miss.

```
printf '%s\n' 'going to crash' 'a compiler' 'a honey bee' > /tmp/exact-word-book.txt
./scripts/exact-word /tmp/exact-word-book.txt going to chrash ; echo "miss:$?"
./scripts/exact-word /tmp/exact-word-book.txt going to crash ; echo "hit:$?"
```

To add another tool, do only this:

1. Write `notebook/tools/<name>.md`. One job. One detect. No secret.
2. Write `scripts/<name>`. Paths relative to this folder.
3. Run it. Record the pass line and the fail line.
4. Link `[[<name>]]` from `notebook/Index.md`.
5. If the detect fails, delete the script and write it again from the note. Do not add a score to force a pass.

### 4. Hop-80

Unbounded context means the old session is not shrunk into a paragraph. The packet is short. Files stay on disk.

```
./scripts/hop-scope \
  --goal 'Prove the packet on this host.' \
  --edge head \
  --in-scope notebook/Index.md \
  --out-of-scope secrets \
  --trim 'This trim is long enough to pass the forty character minimum for a hop packet.'
```

Slogan, must refuse:

```
printf '%s\n' 'kind: hop' 'goal: Continue.' 'edge: head' 'in_scope:' '- notebook/Index.md' 'out_of_scope:' '- secrets' 'trim:' 'This trim is long enough to pass the forty character minimum for a hop packet.' \
  | ./scripts/hop-scope --validate ; echo "slogan:$?"
```

If `hermes` exists, read the switch. Do not turn it on.

```
hermes config get compression.enabled
```

Fire path, on this computer's agent source, not a path from another home:

```
rg -n '_fire_cutover_at_threshold' 
```

Zero hits means the automatic fire is absent. Say so. The packet tool still works. Do not invent a setting.

### 5. Search, then open

Place the index at `data/knowledge.sqlite` only after the operator names the door. Do not look in another home.

```
./scripts/search-open data/knowledge.sqlite nightlight
```

WORD is the list. MEANING is not this step. Do not average them. Do not ask the chat model to look it up. Do not unload the chat model. Do not run an embed model on a small host.

### 6. Local disc

Place the simple disc at `data/simple.zim` only after the operator names the door. About 1 GB. Not the 50 GB English file.

```
./scripts/zim-search data/simple.zim photosynthesis
```

Titles are the working proof. If a later server lists `search_leads`, you started the fat server. Stop.

## Expected output

Omarchy, on this host. The MSI must print its own line. Do not copy this stamp.

```
omarchy arch 4.0.0
4.0.0-1
stable
```

Notebook:

```
PASS notebook ./notebook
```

Exact word:

```
miss:1
1:going to crash
hit:0
```

Hop packet starts:

```
kind: hop
goal: Prove the packet on this host.
edge: head
```

Slogan:

```
refuse: slogan is not a goal
slogan:6
```

Search, when the index is in place:

```
WORD
<doc>:<line>
MEANING
not this step. Do not fuse. Do not ask the chat model.
```

Disc, when the simple file is in place. First title:

```
Photosynthesis
```

Append one line per step to `procedure-state.md` on this computer. Do not commit it.

```
STEP <n> PASS|FAIL <one fact>
```

## Recovery

Run `bootstrap-vault` again. It writes missing files only. It does not wipe a note you edited.

If hop-scope refuses a packet you know is valid, copy `scripts/hop-scope` again. Do not edit it to accept `Continue.`

If search prints one mixed number, delete that script and use `scripts/search-open`.

If the disc step fetched a multi-tens-of-GB file, delete it. That file does not belong on this node.

## Next steps

Stop when the detects above are reported. Do not open peer memory. Do not copy a house voice.

Closed until the operator publishes them:

- Meaning search, only if an embed model is already up on a warehouse. Not on a small host.
- Opening a disc page after the title, once a thin reader is in this folder. Titles are enough for this pass.
- Automatic hop fire, only after the mixin detect hits. The packet is the working example today.
