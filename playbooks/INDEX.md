# Playbooks

Read this before you run anything. Reading a card does not install it. The operator says go. Then run published cards in order.

| Order | id | Tier | Published | Memory | Model | Minutes |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | base-node | base | yes | small | none | 45 |

`base-node` is the page. It opens the notebook, shows how to add a tool, and proves three working examples: hop packet, word search, local disc.

Pieces it calls, already in this folder:

| id | Role |
| --- | --- |
| obsidian-toolbox | Create the notebook. |
| exact-word | The pattern for a new tool. |

Closed. No folder. Do not invent them.

| id | Why it is closed |
| --- | --- |
| peer-memory | Not the classroom store. |
| persona | A new node writes its own. Do not copy a house voice. |

Open a card only by its folder: `playbooks/<id>/README.md`. Read `playbook.json` first. If `published` is not true, stop.
