# Scripts

Download is this folder. A clone is the download. Do not fetch a warehouse.

| Script | Playbook | What pass looks like |
| --- | --- | --- |
| bootstrap-vault | base-node | `PASS notebook ./notebook` |
| exact-word | base-node | typo exits 1; real words print the line |
| hop-scope | base-node | packet prints; `Continue.` exits 6 |
| search-open | base-node | WORD list, then MEANING not this step |
| zim-search | base-node | titles; photosynthesis starts with Photosynthesis |
| detect-base | exact-word | last line `STOP PASS` |

From the toolbox root:

```
chmod +x scripts/bootstrap-vault scripts/exact-word scripts/detect-base
./scripts/bootstrap-vault
./scripts/detect-base
```

`detect-base` fails until the notebook exists. Run bootstrap first.
