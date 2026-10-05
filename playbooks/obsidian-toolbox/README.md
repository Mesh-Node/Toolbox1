# Open the toolbox notebook

## Overview

The toolbox is an Obsidian notebook on this computer. This playbook creates that notebook. It does not install a model. It does not copy another home.

You will see a folder you can open in Obsidian, or read as plain files if the app is not installed. The files are the pass.

## What you'll learn

- The notebook is the toolbox. A pile of scripts without notes is not.
- Seed tools stay in the seed. This notebook links them. It does not copy them.
- A missing app is not a fail. Missing notes are a fail.

## Prerequisites

- Mesh-Node/mesh-node already said Stop.
- POSIX `sh` and `mkdir`.
- No model. No warehouse. Small memory is enough.

If the seed folder is missing, stop. Return to the seed. Do not skip.

## Core concepts

One note per tool. Wikilinks are the index: `[[exact-word]]` opens the note named exact-word.

Packets land in `inbox/`. Files stay on disk. The packet names them.

Base tools are the ones in `BASE.md`. Unpublished cards are closed. Do not open them because you can.

## Main activity

From the toolbox root:

```
chmod +x scripts/bootstrap-vault
./scripts/bootstrap-vault
```

That writes `notebook/` only where a file is missing. It does not overwrite a note you already edited.

Open `notebook/Index.md`. Pause. Which two tools does it link?

It links seed and exact-word. Seed is a pointer. Exact-word is the first tool you will run in the next playbook.

If Obsidian is installed, open this folder as a vault. If it is not, read the markdown. Either way is pass.

## Expected output

```
PASS notebook ./notebook
```

Then these files exist:

```
notebook/Index.md
notebook/tools/seed.md
notebook/tools/exact-word.md
notebook/toolchains/Index.md
notebook/inbox/README.md
```

`Index.md` contains `[[seed]]` and `[[exact-word]]`.

## Next steps

Run `playbooks/exact-word` next. It is published. Operator input: none.

Do not start search, hop, the encyclopedia, peer memory, or a persona. Those cards are unpublished. A classroom machine stops after the published base list.
