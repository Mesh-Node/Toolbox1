#!/bin/sh
# Manual probe. Same check as hop-detect. Does not open a foot.
set -eu
dir=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
exec "$dir/hop-detect.py" --dry-run "$@"
