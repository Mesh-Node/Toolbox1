---
title: "Schema"
type: foundation
status: draft
evidence: untested
verified_on: "2026-10-11"
secrets: false
---

# SCHEMA

Evidence labels (required on synthesized notes):

| Label | Meaning |
|---|---|
| `verified-local` | Observed on this host, with date and method |
| `verified-upstream` | Supported by linked official docs |
| `inferred` | Plausible, awaiting a check on this host |
| `untested` | Proposed procedure, awaiting a run |
| `obsolete` | Historical. Revalidate before use. |

## Write policy

Agent writes `inbox/` on their own: drafts and gaps.

Agent writes these after the operator says yes:

- `tools/`
- `toolchains/`
- `runbooks/`
- `decisions/`
- `foundations/`
- `CHARTER.md`, this file, `index.md`, `tool.md`, `toolchain.md`

## Secrets

`secrets: false` on every note. Credentials stay on the logged-in host, outside this folder.
