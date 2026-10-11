#!/bin/sh
# One Hyprland address. Not a class.
set -eu
addr=${1:-}
[ -n "$addr" ] || { echo "need one address" >&2; exit 2; }
case "$addr" in
  address:0x*) ;;
  0x*) addr="address:$addr" ;;
  *) echo "need one 0x address, not a class" >&2; exit 2 ;;
esac
hyprctl eval "hl.dispatch(hl.dsp.window.close({window=\"$addr\"}))"
