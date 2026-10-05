# hop-80

When the window is about 80% full, start a new foot and continue the current work. Do not summarize.

Script: `scripts/hop-80`

```
scripts/hop-80 "the current work, in one sentence"
HARNESS=hermes scripts/hop-80 "the current work, in one sentence"
```

`HARNESS` swaps the harness. Default is hermes.

The script writes a short packet to the hops folder and opens a new foot with that file as the query. The new foot does not receive the old chat. Files stay on disk. The packet names the work.

`Continue.` is refused. Write the work.

Pass: a new foot opens, and the goal text is the first work it has. The old foot is still there.

See [[toolchains/hop-80]].
