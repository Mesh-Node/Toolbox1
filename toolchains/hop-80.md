# Hop-80

Unbounded context. The old session is not shrunk into a paragraph. A new foot continues the work.

Do these in order.

## 1. Inject

[[inject-foot]] puts text into a foot that is already open. Script: `scripts/inject-foot`

Use this when the other foot exists and you have its window address.

## 2. Bare foot

[[bare-foot]] launches an empty foot. No packet. The harness is the first argument. Default is hermes.

```
scripts/bare-foot
scripts/bare-foot hermes
```

Swap the harness by changing that argument. Do not edit the script to rename it.

## 3. The 80% hop

[[hop-80]] starts a new foot with the current work. Run it when the window is about 80% full. Do not summarize first.

```
scripts/hop-80 "Prove the packet on this host. Continue this work."
```

A slogan is not a goal. `Continue.` is refused.

Compression stays off. That is a harness setting, not this script. If the harness is hermes:

```
hermes config get compression.enabled
```

The line must be `false`. If it is `true`, stop. Tell the operator. Do not turn compression on and call it a hop.

## Prove

1. Launch a bare foot.
2. Inject one sentence into it. The sentence appears. That is pass.
3. Run hop-80 with a real goal. A new foot opens and has that goal. The old chat is not pasted in. That is unbounded context for this kit.
