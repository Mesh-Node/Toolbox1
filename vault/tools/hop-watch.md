---
title: "Tool: hop watch"
type: tool
status: draft
evidence: verified-local
verified_on: "2026-10-11"
secrets: false
protocol: 1.5
---

# hop watch

Manual probe. The live fire is [[hop-detect]], once, at the end of the turn.

Same window math as detect. `--dry-run` is forced. The current foot stays open.

## Command

```
scripts/hop-watch.sh --fake-tokens 210000 --hops /tmp/hop-probe
scripts/hop-watch.sh --fake-tokens 400000 --hops /tmp/hop-probe
```

Point `--hops` at a scratch dir. The live hops dir holds the live packet.

## Out

Under the line, exit 0. At the line, a validating packet on stdout. No new foot.

## Then

[[hop-send]] only from the live hook, not from this probe.

## Ran

2026-10-11, this host. 210000 stayed under line 400000. 400000 printed a packet and left the foot open.
