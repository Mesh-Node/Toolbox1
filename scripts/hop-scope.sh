#!/bin/sh
# hop v1.5 packet on stdout. No hop file.
# Usage:
#   hop-scope.sh --goal TEXT --edge head|tail --in-scope TEXT --out-of-scope TEXT \
#     [--leave] [--constraint TEXT] [--artifact PATH] [--trim TEXT]
#   Repeat --in-scope / --out-of-scope / --constraint / --artifact.
#   --leave optional. hop-detect still sends it. Head is spawn.
#   --trim omitted: read trim from stdin.
#   hop-scope.sh --validate < packet
# Exit: 0 ok, 2 bad args, 6 refuse shape.
set -eu
MAX=4096
VALIDATE=0
GOAL=""
EDGE=""
LEAVE=0
TRIM=""
TRIM_SET=0
IN=""
OUT=""
CON=""
ART=""

append() {
  _n=$1
  _v=$2
  [ -n "$_v" ] || return 0
  eval "_cur=\${$_n}"
  if [ -n "$_cur" ]; then
    eval "$_n=\$(printf '%s\\n%s' \"\$_cur\" \"\$_v\")"
  else
    eval "$_n=\$(printf '%s' \"\$_v\")"
  fi
}

while [ $# -gt 0 ]; do
  case "$1" in
    --validate) VALIDATE=1; shift ;;
    --goal)
      [ $# -ge 2 ] || { echo "need --goal TEXT" >&2; exit 2; }
      GOAL=$2; shift 2
      ;;
    --edge)
      [ $# -ge 2 ] || { echo "need --edge head|tail" >&2; exit 2; }
      case "$2" in
        head|tail) EDGE=$2 ;;
        *) echo "need --edge head|tail" >&2; exit 2 ;;
      esac
      shift 2
      ;;
    --leave) LEAVE=1; shift ;;
    --floor)
      echo "refuse: floor retired. v1.5 uses --edge head|tail" >&2
      exit 2
      ;;
    --in-scope)
      [ $# -ge 2 ] || { echo "need --in-scope TEXT" >&2; exit 2; }
      append IN "$2"; shift 2
      ;;
    --out-of-scope)
      [ $# -ge 2 ] || { echo "need --out-of-scope TEXT" >&2; exit 2; }
      append OUT "$2"; shift 2
      ;;
    --constraint)
      [ $# -ge 2 ] || { echo "need --constraint TEXT" >&2; exit 2; }
      append CON "$2"; shift 2
      ;;
    --artifact)
      [ $# -ge 2 ] || { echo "need --artifact TEXT" >&2; exit 2; }
      append ART "$2"; shift 2
      ;;
    --trim)
      [ $# -ge 2 ] || { echo "need --trim TEXT" >&2; exit 2; }
      TRIM=$2; TRIM_SET=1; shift 2
      ;;
    -h|--help)
      printf '%s\n' "usage: hop-scope.sh --goal TEXT --edge head|tail --in-scope TEXT --out-of-scope TEXT [--leave] [--constraint TEXT] [--artifact PATH] [--trim TEXT]"
      printf '%s\n' "       hop-scope.sh --validate < packet"
      exit 0
      ;;
    *)
      printf 'unknown arg: %s\n' "$1" >&2
      exit 2
      ;;
  esac
done

list_yaml() {
  _any=0
  while IFS= read -r _line || [ -n "$_line" ]; do
    [ -n "$_line" ] || continue
    printf -- '- %s\n' "$_line"
    _any=1
  done
  [ "$_any" -eq 1 ] || printf '%s\n' "[]"
}

check() {
  _p=$1
  if printf '%s' "$_p" | jq -e '.output|type=="string"' >/dev/null 2>&1; then
    _p=$(printf '%s' "$_p" | jq -r .output)
  fi
  _p=$(printf '%s\n' "$_p" | awk 'BEGIN{p=0} NF{p=1} p')
  _n=$(printf '%s' "$_p" | wc -c)
  if [ "$_n" -eq 0 ]; then
    echo "refuse: empty packet" >&2
    return 6
  fi
  if [ "$_n" -gt "$MAX" ]; then
    printf 'refuse: packet %s bytes > %s (not a trim)\n' "$_n" "$MAX" >&2
    return 6
  fi
  printf '%s\n' "$_p" | grep -q '^kind: hop$' || { echo "refuse: missing kind: hop" >&2; return 6; }
  _first=$(printf '%s\n' "$_p" | sed -n '/./{p;q}')
  [ "$_first" = "kind: hop" ] || { echo "refuse: packet must start with kind: hop" >&2; return 6; }
  _goal=$(printf '%s\n' "$_p" | sed -n 's/^goal:[[:space:]]*//p' | head -n1)
  [ -n "$_goal" ] || { echo "refuse: empty goal" >&2; return 6; }
  _edge=$(printf '%s\n' "$_p" | sed -n 's/^edge:[[:space:]]*//p' | head -n1)
  case "$_edge" in
    head|tail) ;;
    *) echo "refuse: missing edge: head|tail" >&2; return 6 ;;
  esac
  if printf '%s\n' "$_p" | grep -q '^floor:'; then
    echo "refuse: floor retired. use edge: head|tail" >&2
    return 6
  fi
  _leave=$(printf '%s\n' "$_p" | sed -n 's/^leave:[[:space:]]*//p' | head -n1)
  if [ -n "$_leave" ]; then
    [ "$_leave" = "yes" ] || { echo "refuse: leave must be yes" >&2; return 6; }
    [ "$_edge" = "head" ] || { echo "refuse: leave only with edge: head" >&2; return 6; }
  fi
  _g=$(printf '%s' "$_goal" | tr '[:upper:]' '[:lower:]')
  case "$_g" in
    *"inflate from disk"*|continue|continue.) echo "refuse: slogan is not a goal" >&2; return 6 ;;
    *"hop is the last assistant"*) echo "refuse: slogan is not a goal" >&2; return 6 ;;
  esac
  printf '%s\n' "$_p" | grep -q '^in_scope:$' || { echo "refuse: missing in_scope" >&2; return 6; }
  printf '%s\n' "$_p" | grep -q '^out_of_scope:$' || { echo "refuse: missing out_of_scope" >&2; return 6; }
  printf '%s\n' "$_p" | grep -q '^trim:$' || { echo "refuse: missing trim" >&2; return 6; }
  _in=$(printf '%s\n' "$_p" | awk 'BEGIN{p=0} /^in_scope:$/{p=1;next} /^[a-z_]+:/{p=0} p && /^- /{c++} END{print c+0}')
  _out=$(printf '%s\n' "$_p" | awk 'BEGIN{p=0} /^out_of_scope:$/{p=1;next} /^[a-z_]+:/{p=0} p && /^- /{c++} END{print c+0}')
  [ "$_in" -ge 1 ] || { echo "refuse: in_scope needs at least one item" >&2; return 6; }
  [ "$_out" -ge 1 ] || { echo "refuse: out_of_scope needs at least one item" >&2; return 6; }
  _trim=$(printf '%s\n' "$_p" | awk 'BEGIN{p=0} /^trim:$/{p=1;next} p{print}')
  _tn=$(printf '%s' "$_trim" | tr -d '[:space:]' | wc -c)
  [ "$_tn" -ge 40 ] || { echo "refuse: trim too thin" >&2; return 6; }
  if [ "$VALIDATE" -eq 1 ]; then
    printf '%s\n' "$_p"
  fi
  return 0
}

if [ "$VALIDATE" -eq 1 ]; then
  PACKET=$(cat)
  check "$PACKET"
  exit $?
fi

[ -n "$GOAL" ] || { echo "need --goal" >&2; exit 2; }
[ -n "$EDGE" ] || { echo "need --edge head|tail" >&2; exit 2; }
[ -n "$IN" ] || { echo "need --in-scope" >&2; exit 2; }
[ -n "$OUT" ] || { echo "need --out-of-scope" >&2; exit 2; }
if [ "$LEAVE" -eq 1 ] && [ "$EDGE" != "head" ]; then
  echo "refuse: --leave only with --edge head" >&2
  exit 2
fi
if [ "$TRIM_SET" -eq 0 ]; then
  if [ -t 0 ]; then
    echo "need --trim TEXT or trim on stdin" >&2
    exit 2
  fi
  TRIM=$(cat)
fi
[ -n "$TRIM" ] || { echo "need trim" >&2; exit 2; }

PACKET=$(
  printf '%s\n' "kind: hop" "goal: $GOAL" "edge: $EDGE"
  if [ "$LEAVE" -eq 1 ]; then printf '%s\n' "leave: yes"; fi
  printf '%s\n' "constraints:"
  if [ -n "$CON" ]; then printf '%s\n' "$CON" | list_yaml; else printf '%s\n' "[]"; fi
  printf '%s\n' "artifacts:"
  if [ -n "$ART" ]; then printf '%s\n' "$ART" | list_yaml; else printf '%s\n' "[]"; fi
  printf '%s\n' "in_scope:"
  printf '%s\n' "$IN" | list_yaml
  printf '%s\n' "out_of_scope:"
  printf '%s\n' "$OUT" | list_yaml
  printf '%s\n' "trim:" "$TRIM"
)

check "$PACKET" || exit 6
printf '%s\n' "$PACKET"
exit 0
