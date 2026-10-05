# Hop-80 tools

House scripts. Do not edit them. Do not put secrets in a hop packet.

## hop-scope.sh

Builds the packet on stdout.

`--goal TEXT --edge head|tail` plus `--in-scope`, `--out-of-scope`, `--constraint`, `--artifact`, optional `--trim`.

`--validate` checks a packet shape. Exit 6 = refuse shape.

`--leave` is still accepted for hop-80. Head means spawn a new session. Tail means send back. Origin stays unless the edge is head with leave.

## hop-send.sh

No arguments. Edge is on the packet (`head` or `tail`).

Head: spawn a new foot. Record origin. The new foot is tail-only.

Tail: put the packet into origin. No spawn.

`leave: yes` still accepted. The first command in the new session closes the sender by window address — one address, never a class of windows.

## What the new session gets

A short packet: goal, in-scope file paths, out-of-scope, artifacts, trim.

It does **not** get the old chat. It does not get passwords. Files stay on disk; the packet names them.

## What fires a hop

Compression stays off. When the prompt is about 80% of the local model’s context, hop-80 may start a new session instead of summarizing.

## Refuse

Slogan goals such as `Continue.` or `inflate from disk` are refused.

Do not invent extra labels. Do not say dest/desting.
