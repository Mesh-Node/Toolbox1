# Playbook — not the quick start

Do not follow this file on a new node. QUICKSTART.md is the basic toolbox. This file is expansion notes. Open it only after QUICKSTART says Stop and the operator says expand.

# Playbook — small host, three tools

You are the agent on the destination host. This folder is the toolbox. You bring the model.

A human and an agent read this same file. Pause when it asks. Then run the step. If it is not written here, it is not a step.

Paths are relative to this folder. If a note tells you to open another user's home, stop. That note was written for a different computer.

## Law

Seed first, then this kit. Local first. GitHub last.

No passwords. No one else's home. No model weights. No peer-memory database. No chat history.

The operator names one door. You do not invent a door. You do not log into an overlay.

If a tool has no lesson, it is not in this toolbox.

## Operator fills these before send

Leave a line blank if unknown. Do not guess.

```
Host class:
Search store: copy | leave on warehouse
Encyclopedia: leave on warehouse | copy the small disc
Door:
```

Host class `small` means about 6GB of memory. It calls tools. It does not load a large chat model. It does not hold a 50G disc.

## 0. Point

1. If this host has no copy of the seed, copy Mesh-Node/mesh-node first. Read its procedure. Stop when it says Stop.
2. Then open this folder.
3. Open `lessons/INDEX.html` in a browser. One lesson. Pause before you interpret.

Detect: the seed contains a house name, a host path, or a costume. Wrong layer. Stop.

## 1. Hop-80 — when the window is full

Lesson: `hop-80/lesson-hop-80.html`
Note: `hop-80/TOOLS.md`

Open the lesson. Answer the pause before you read the red line.

The new session gets a short packet: goal, in-scope paths, out-of-scope, artifacts, trim. It does not get the old chat. Files stay on disk. The packet names them.

Head means forward: a new session. Tail means back: the packet returns to the origin. The origin stays unless the edge is head and leave is set. Close is one window address. Never a class of windows.

Compression stays off. The 80% mark is the moment a hop may start. It is not a summarizer.

Refuse a slogan goal. `Continue.` is not a goal. `inflate from disk` alone is not a goal. Write what to do and which files.

Detect, on this host:

```
rg -n '_fire_cutover_at_threshold' 
```

Run that against the agent source on this computer, not against a path from another home.

Zero hits means the fire path is absent. Say so. Do not invent a setting to make it fire. The packet rule still holds.

The house send script does not travel in this playbook. It closes a window by talking to one desktop. If this host is not that desktop, copying the script will fail or close the wrong window. Packet shape travels. That script does not, until the operator says this host is the same desktop.

## 2. Search, then open the page

Lesson: `omarchy-search/lesson-search.html`

Open the lesson. Answer the pause.

This tool finds passages in local notes. It is not a chatbot.

1. Search.
2. Open the page.

Word search and meaning search are two lists. Do not add the scores. Do not treat one mixed number as the rank.

Do not ask the chat model to look it up. Do not unload the chat model to run search. Meaning search uses a small embed model on the warehouse. The small host does not run that embed model.

Charge the index once, when the source is verified. Do not ingest on every chat.

A command path on the warehouse is not a command on this host. A stdio tool does not cross an overlay by itself.

If the operator wrote `copy`: the index file comes with this folder, and word search works with the warehouse down. Meaning search still calls the warehouse embed model. It does not move here.

If the operator wrote `leave on warehouse`: you have directions only. You call a door the operator named. If no door is named, stop. Do not invent a URL. Do not pretend a remote path is local.

Detect: the transcript shows a chat-model lookup, or one fused score. Fail. Search, then open. Two lists.

## 3. Wikipedia — thin tool

There is no lesson file for this tool yet. Until that page exists, this section is the lesson. Same rule: pause, then run.

You type words. A local encyclopedia returns titles, then page text. First list is the search. Second list is pages reached by following links. Like-the-question is not the same as typical-of-this-pile. Keep two lists.

The thin tool exposes exactly three calls:

```
topic_open
search_zim
get_zim
```

Probe: `topic_open` with three queries, separated by ` | `:

```
honey bee | compiler | electric power distribution
```

Detect: the tool list includes `search_leads`. You started the fat server. Stop. Thin only.

The large disc stays on the warehouse. A small host does not hold it. Do not re-fetch it. Do not embed it.

The small disc stays on the warehouse unless the operator wrote `copy the small disc`.

Default listen address is this host only (`127.0.0.1`). Bind a wider address only if the operator wrote the bind on the Door line. The bind target is that named address. Not every interface. Not a public funnel.

If the warehouse stays there and this host must call it, the operator names the door. You do not open one.

## 4. Send

The operator sends this folder. You do not send a home directory.

Before send, from the donor:

- This file uses no other user's home path.
- The three lessons (or this section, for the thin encyclopedia) can be opened without a server.
- Operator lines above are filled or explicitly blank.
- No secrets, no weights, no peer-memory database, no chat database, no large disc.

If the donor is logged out of the overlay, it cannot send on that door. Say so. Login is the operator's step.

Receiver accept is the gate.

## 5. Done when

On the destination, in order:

1. Seed is present, or the operator said this host already has it.
2. `lessons/INDEX.html` opens.
3. Hop-80 lesson opens. Fire-path detect has a result: present, or absent and reported. No invented setting.
4. Search lesson opens. The operator line says copy or leave. You did not fuse scores. You did not ask the chat model.
5. Thin encyclopedia lists exactly the three calls, or you stopped because the fat server answered.
6. You wrote one line per step on this computer:

```
STEP <n> PASS|FAIL <one fact>
```

That state file stays on this computer. Do not commit it.

## 6. Stop

Report the three detect results and the working door. Stop. Do not watch the overlay. Do not poll.

## Do not

- Put this playbook in the public seed. The seed is how to read a packet. This file is a kit.
- Git push until a human has followed this file on a computer that did not write it.
- Point students at an uncensored model.
- Turn compression on and call it a hop.
- Funnel the chat model or the encyclopedia onto the public net.

## GitHub

Private repo: Mesh-Node/Toolbox1. Tools ship as lessons. This file is the front door.

The public seed stays Mesh-Node/mesh-node. No house names there. No host paths. No this playbook.
