---
title: "Tool: packet build"
type: tool
status: draft
evidence: verified-local
verified_on: "2026-10-11"
secrets: false
protocol: 1.5
example: true
---

# packet build

Write a validating hop packet to stdout. The note is the tool. The script is the pointer.

`edge: head|tail` is the send. Head goes forward. Tail goes back.

`--goal` is the work. The goal is one real task sentence.

`--leave` is optional. [[hop-detect]] still sends it. The mixin does not.

## Command

```
scripts/hop-scope.sh \
  --goal '<one sentence>' \
  --edge head \
  --in-scope '<path>' \
  --out-of-scope '<item>' \
  --leave \
  --trim '<text>'

scripts/hop-scope.sh --validate < packet
```

## In

`--goal` is set. `--edge` is head or tail. `--in-scope` has at least one item. `--out-of-scope` has at least one item. `--trim` has at least 40 non-space characters. The packet stays within 4096 bytes. The first line is `kind: hop`.

## Out

Stdout starts `kind: hop`. Then `goal:`, `edge:`, and `leave: yes` when leave is set.

## Then

[[hop-send]].
