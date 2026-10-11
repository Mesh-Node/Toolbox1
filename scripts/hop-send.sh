#!/bin/sh
# hop v1.5 send. No argv. edge: head|tail on the packet.
# head: spawn. New foot is tail-only. Record origin.
# tail: packet into origin. No spawn.
# leave: yes still accepted (hop-80). First command closes sender.
set -eu
HOPS="${HERMES_HOPS:-$HOME/.hermes/hops}"
STATE="${HERMES_HOME:-$HOME/.hermes}/state.db"

if [ $# -gt 0 ]; then
  echo "refuse: no argv. edge: head|tail is on the packet." >&2
  exit 2
fi

mkdir -p "$HOPS"
umask 077

pid=$$
FOOT=""
i=0
while [ "$pid" != 1 ] && [ "$i" -lt 16 ]; do
  comm=$(ps -o comm= -p "$pid" 2>/dev/null | tr -d ' ')
  if [ "$comm" = "foot" ]; then
    FOOT=$pid
    break
  fi
  pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
  [ -n "$pid" ] || break
  i=$((i + 1))
done
[ -n "$FOOT" ] || { echo "no ancestor foot" >&2; exit 3; }

ADDR=$(hyprctl clients -j | jq -r --argjson p "$FOOT" '.[] | select(.pid==$p) | .address' | head -n1)
[ -n "$ADDR" ] || { echo "no hypr client for foot $FOOT" >&2; exit 4; }

SESSION=$(sqlite3 -readonly "$STATE" \
  "SELECT id FROM sessions WHERE COALESCE(archived,0)=0 AND COALESCE(hidden,0)=0 ORDER BY last_activity_at DESC LIMIT 1;")
[ -n "$SESSION" ] || { echo "no session" >&2; exit 5; }

DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
SCOPE="${HOP_SCOPE:-${CUTOVER_SCOPE:-$DIR/hop-scope.sh}}"
HOP=""
if [ ! -t 0 ]; then
  IN=$(cat)
  if [ -n "$IN" ]; then
    HOP=$(printf '%s\n' "$IN" | "$SCOPE" --validate 2>/dev/null) || {
      echo "refuse: stdin is not a validating packet" >&2
      exit 6
    }
  fi
fi
if [ -z "$HOP" ]; then
  CAND=$(sqlite3 -readonly "$STATE" \
    "SELECT content FROM messages WHERE session_id='$SESSION' AND role='assistant' AND length(content)>0 ORDER BY id DESC LIMIT 1;")
  if [ -n "$CAND" ]; then
    HOP=$(printf '%s\n' "$CAND" | "$SCOPE" --validate 2>/dev/null) || HOP=""
  fi
fi
if [ -z "$HOP" ]; then
  i=0
  while [ "$i" -lt 8 ]; do
    CAND=$(sqlite3 -readonly "$STATE" \
      "SELECT content FROM messages WHERE session_id='$SESSION' AND role='tool' AND length(content)>0 ORDER BY id DESC LIMIT 1 OFFSET $i;")
    [ -n "$CAND" ] || break
    HOP=$(printf '%s\n' "$CAND" | "$SCOPE" --validate 2>/dev/null) || HOP=""
    [ -n "$HOP" ] && break
    i=$((i + 1))
  done
fi
[ -n "$HOP" ] || { echo "refuse: no validating packet (run hop-scope.sh first)" >&2; exit 6; }

EDGE=$(printf '%s\n' "$HOP" | sed -n 's/^edge:[[:space:]]*//p' | head -n1)
LEAVE=$(printf '%s\n' "$HOP" | sed -n 's/^leave:[[:space:]]*//p' | head -n1)
TAILFILE="$HOPS/tail"

printf '%s\n' "$HOP"

if [ "$EDGE" = "tail" ]; then
  SAVED=""
  [ -f "$TAILFILE" ] && SAVED=$(tr -d ' \n' < "$TAILFILE")
  [ -n "$SAVED" ] || { echo "refuse: no tail origin" >&2; exit 6; }
  [ "$SAVED" != "$ADDR" ] || { echo "refuse: tail origin is this foot" >&2; exit 6; }
  LIVE=$(hyprctl clients -j | jq -r --arg a "$SAVED" '.[] | select(.address==$a) | .address' | head -n1)
  [ "$LIVE" = "$SAVED" ] || { echo "refuse: tail origin dead" >&2; exit 6; }
  RECORD=$(printf 'tail session %s pid %s address %s -> %s\n' \
    "$SESSION" "$FOOT" "$ADDR" "$SAVED")
  printf '%s\n' "$RECORD"
  omarchy notification send --app-name hermes -u normal "hop tail" "$RECORD" || true
  hyprctl eval "hl.dispatch(hl.dsp.focus({window=\"address:$SAVED\"}))" || true
  printf '%s\n' "$HOP" | wl-copy
  wtype -M ctrl -M shift v -m shift -m ctrl
  wtype -k Return
  exit 0
fi

[ "$EDGE" = "head" ] || { echo "refuse: edge must be head or tail" >&2; exit 6; }

CLOSE_CMD=$(printf "hyprctl eval 'hl.dispatch(hl.dsp.window.close({window=\\\"address:%s\\\"}))'" "$ADDR")
if [ "$LEAVE" = "yes" ]; then
  FIRST=$CLOSE_CMD
  NOTE="You have tail only. Run First command (close that one address). Then do the goal. Never edge: head."
else
  FIRST="none. You have tail only. Do the goal. Write dest. Then edge: tail. Never edge: head. Never close the origin."
  NOTE="Inflate in-scope. Do the goal. Dest. Then packet edge: tail. Never spawn."
  printf '%s\n' "$ADDR" > "$TAILFILE"
  chmod 600 "$TAILFILE"
fi

{
  printf '%s\n' \
    "$HOP" \
    "" \
    "origin session $SESSION pid $FOOT address $ADDR edge $EDGE" \
    "" \
    "First command:" \
    "$FIRST" \
    "" \
    "$NOTE"
} > "$HOPS/receive-query.md"

RECORD=$(printf 'head session %s pid %s address %s\n' \
  "$SESSION" "$FOOT" "$ADDR")
printf '%s\n' "$RECORD"
omarchy notification send --app-name hermes -u normal "hop head" "$RECORD" || true

setsid -f env \
  -u HERMES_SESSION_ID \
  -u HERMES_SESSION_SOURCE \
  -u HERMES_SESSION_CHAT_ID \
  -u HERMES_SESSION_CHAT_NAME \
  -u HERMES_SESSION_CHAT_TYPE \
  -u HERMES_SESSION_THREAD_ID \
  -u HERMES_SESSION_USER_ID \
  -u HERMES_SESSION_USER_ID_ALT \
  -u HERMES_SESSION_USER_NAME \
  -u HERMES_SESSION_PLATFORM \
  -u HERMES_SESSION_PROFILE \
  -u HERMES_SESSION_SCOPE_ID \
  -u HERMES_SESSION_MESSAGE_ID \
  -u HERMES_UI_SESSION_ID \
  -u HERMES_TUI_ACTIVE_SESSION_FILE \
  omarchy launch tui --app-id=org.omarchy.agent \
  hermes chat --cli --in "$HOPS" --query-file "$HOPS/receive-query.md" \
  >/dev/null 2>&1

exit 0
