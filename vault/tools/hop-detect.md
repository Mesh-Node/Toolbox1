---
title: "Tool: hop detect"
type: tool
status: draft
evidence: verified-local
verified_on: "2026-10-11"
secrets: false
protocol: 1.5
---

# hop detect

End of turn. When this session's prompt is at or over 80% of that session's window, build a packet and call hop-send.

The line is `int(window * 0.8)`. Not a hardcoded 400000.

Window, first hit:

1. `--context` if passed
2. `HERMES_CONTEXT_LENGTH`, unless it is at or under 65536 and the model name contains grok
3. `model.context_length` in config, if set
4. xAI card `~/.hermes/cache/endpoint_model_metadata.json`
5. house map: grok-4.7, grok-4.6, grok-4.5 = 500000
6. else 256000

grok-4.7 card is 500000. Line is 400000. A real 65536 model still uses line 52428.

Compaction stays off. One latch per session, so it fires once.

## Command

```
scripts/hop-detect.py
scripts/hop-detect.py --dry-run
```

Hermes calls it from `hooks.post_llm_call`. `--dry-run` prints the packet and does not open a foot. Point `--hops` at a scratch dir when testing.

## In

Session id from the hook payload. Prompt size from the saved anchor. Window from the list above.

## Out

Under the line the script exits 0 and the turn continues. Over the line it writes a validating packet, then [[hop-send]].

## Ran

2026-10-11, this host. grok-4.7, fake 210000, scratch hops dir: window 500000, line 400000, exit 0. Fake 400000 `--dry-run`: validating packet, no foot opened.

## Then

[[packet-build]], then [[hop-send]].
