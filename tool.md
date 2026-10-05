# tool

A tool is a small deterministic piece.

Same input, same output. Every time. If a one-letter change should miss, it misses. If a slogan should be refused, it is refused. No score added to force a pass.

## Pieces

1. One job, written in a note.
2. One script, named by that note. The script lives in `scripts/`.
3. One real run. Record what came back.
4. Promote only after that run.

A pile of HTML is not a tool. A script with no note is not in the toolbox.

## Promote

Add the note under `tools/`. Link it from [[tools/Index]]. The note links the script:

```
scripts/<name>
```

Until that link exists, the tool is not promoted.

See [[workflow]].
