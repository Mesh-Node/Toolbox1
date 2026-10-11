---
title: "hop-80"
type: chain
status: draft
evidence: verified-local
verified_on: "2026-10-11"
secrets: false
protocol: 1.5
alias: cutover
example: true
tools:
  - "[[hop-detect]]"
  - "[[packet-build]]"
  - "[[hop-send]]"
  - "[[close-the-foot]]"
---

# hop-80

Compaction stays off. At 80% of this session's window, the tools run in this order. The note is the order.

The window is not 256000. grok-4.7 is 500000 on the xAI card. The line is `int(window * 0.8)` = 400000. Not a hardcoded 400000.

```
[[hop-detect]]
[[packet-build]]
[[hop-send]] edge: head, leave: yes
[[close-the-foot]] one address
```

Detect reads the session. Packet-build writes the packet. Hop-send opens one new foot. The packet's first command is [[close-the-foot]] for that one donor address. Never a class.

## This

- The live fire is [[hop-detect]], once, at the end of the turn.
- [[hop-watch]] is the manual probe.
- This host sends with [[hop-send]], one foot.
- Close uses one Hyprland address.
- The new foot reads the packet. It does not get the old chat.

## Ran

2026-10-11, this host. The detect script, pointed at a scratch hops dir, with fake 210000 tokens, printed window 500000, line 400000, and exited 0. Fake 400000 with `--dry-run` printed a validating packet and did not open a foot.
