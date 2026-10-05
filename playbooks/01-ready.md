# Omarchy and a house agent

This toolbox is for Omarchy.

## Overview

You already have Omarchy. You already have a house agent in a harness. A house agent is the agent that belongs to this host. The harness is the program that runs it. This step only checks those two facts. It does not install. It does not download.

## What you'll learn

- This toolbox starts only when both are true.
- A failed check is a stop. It is not a prompt to invent an install.

## Requirements

Nothing to install. The node already has both.

## Procedure

From this folder:

```
chmod +x scripts/ready
./scripts/ready
```

The harness command this toolbox checks is `hermes`. That is the harness. If your harness uses another command, stop and tell the operator. Do not rename the check.

## Expected output

```
PASS omarchy
PASS harness
STOP PASS
```

## Failure

`FAIL omarchy` means this host is not Omarchy. Stop.

`FAIL harness` means `hermes` is not on PATH. Stop.

Do not install packages. Do not copy a home. Do not open another playbook. There is no next playbook yet.

## Next steps

Stop. Report the two lines.
