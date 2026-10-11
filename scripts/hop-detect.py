#!/usr/bin/env python3
"""End-of-turn hop detect for Omarchy. One shot. Not a daemon.

Hermes runs this from a post_llm_call shell hook. Over the line it builds a
packet and calls hop-send.sh beside this file. Exit 0 under the line so the
turn is not blocked. --dry-run prints the packet and does not open a foot.
"""
from __future__ import annotations

import json
import os
import re
import sqlite3
import subprocess
import sys
from pathlib import Path

DEFAULT_WINDOW = 256_000
# Hermes MINIMUM_CONTEXT_LENGTH. Not a model window.
FLOOR = 65_536


def _payload() -> dict:
    if sys.stdin is None or sys.stdin.isatty():
        return {}
    raw = sys.stdin.read()
    if not raw.strip():
        return {}
    try:
        data = json.loads(raw)
    except json.JSONDecodeError:
        return {}
    return data if isinstance(data, dict) else {}


def _session_field(db: Path, sid: str, field: str) -> str:
    if not sid or not db.is_file() or field not in {"model", "title"}:
        return ""
    con = sqlite3.connect(f"file:{db}?mode=ro", uri=True)
    try:
        row = con.execute(f"select {field} from sessions where id=?", (sid,)).fetchone()
    finally:
        con.close()
    return str(row[0] or "") if row else ""


def _model_window(model: str) -> int:
    """Model window. Endpoint card, then house map. 256000 is only the last resort.

    grok-4.7 is 500000 on https://api.x.ai/v1. The catalog key grok-4 is 256000
    and used to win because grok-4.7 was missing. The hop line is 0.8 * this window.
    """
    want = model.lower().rsplit("/", 1)[-1]
    card = Path.home() / ".hermes" / "cache" / "endpoint_model_metadata.json"
    if want and card.is_file():
        try:
            data = json.loads(card.read_text())
        except json.JSONDecodeError:
            data = {}
        best = 0
        if isinstance(data, dict):
            for endpoint in data.values():
                models = endpoint.get("models") if isinstance(endpoint, dict) else None
                if not isinstance(models, dict):
                    continue
                for name, meta in models.items():
                    if str(name).lower() != want or not isinstance(meta, dict):
                        continue
                    n = meta.get("context_length")
                    if isinstance(n, int) and n > best:
                        best = n
        if best:
            return best
    for key, window in (("grok-4.7", 500_000), ("grok-4.6", 500_000), ("grok-4.5", 500_000)):
        if key in model.lower():
            return window
    return DEFAULT_WINDOW


def _window(config: Path, override: int | None, model: str = "") -> int:
    if override:
        return override
    env = os.environ.get("HERMES_CONTEXT_LENGTH", "").strip()
    if env.isdigit():
        env_n = int(env)
        # The 8B fill spike exports 65536. hop-send does not unset it, so
        # every grok child inherits the floor, crosses line 52428, and re-fires.
        if not (env_n <= FLOOR and "grok" in model.lower()):
            return env_n
    if not config.is_file():
        return _model_window(model)
    in_model = False
    for line in config.read_text(errors="replace").splitlines():
        if re.match(r"^model:\s*$", line):
            in_model = True
            continue
        if in_model and re.match(r"^[A-Za-z].*:", line):
            break
        m = re.match(r"^\s+context_length:\s*(\d+)\s*$", line)
        if in_model and m:
            return int(m.group(1))
    return _model_window(model)


def main() -> int:
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("--fake-tokens", type=int, default=None)
    ap.add_argument("--context", type=int, default=None)
    ap.add_argument("--session", default=None)
    ap.add_argument("--state", default=str(Path.home() / ".hermes" / "state.db"))
    ap.add_argument("--config", default=str(Path.home() / ".hermes" / "config.yaml"))
    ap.add_argument("--hops", default=str(Path.home() / ".hermes" / "hops"))
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    payload = _payload()
    db = Path(args.state)
    sid = args.session or str(payload.get("session_id") or "")
    model = _session_field(db, sid, "model")
    if not sid and db.is_file():
        con = sqlite3.connect(f"file:{db}?mode=ro", uri=True)
        try:
            row = con.execute(
                "select id, coalesce(model,'') from sessions "
                "where coalesce(archived,0)=0 order by last_activity_at desc limit 1"
            ).fetchone()
        finally:
            con.close()
        if row:
            sid, model = str(row[0]), str(row[1] or "")
    window = _window(Path(args.config), args.context, model)
    line = int(window * 0.8)
    tokens = args.fake_tokens
    if tokens is None and db.is_file() and sid:
        con = sqlite3.connect(f"file:{db}?mode=ro", uri=True)
        try:
            row = con.execute(
                "select json_extract(model_config, '$._usage_anchor.prompt_tokens') from sessions where id=?",
                (sid,),
            ).fetchone()
        finally:
            con.close()
        tokens = int(row[0] or 0) if row else 0
    if tokens is None and db.is_file():
        con = sqlite3.connect(f"file:{db}?mode=ro", uri=True)
        try:
            row = con.execute(
                "select id, json_extract(model_config, '$._usage_anchor.prompt_tokens') "
                "from sessions where coalesce(archived,0)=0 order by last_activity_at desc limit 1"
            ).fetchone()
        finally:
            con.close()
        if row:
            sid, tokens = row[0], int(row[1] or 0)
    tokens = int(tokens or 0)
    print(f"session {sid or 'none'} prompt_tokens {tokens} line {line} window {window}", file=sys.stderr)
    if tokens < line:
        print("below 80%")
        return 0
    title = _session_field(db, sid, "title")
    real_line = int(_model_window(model) * 0.8)
    if title.startswith("Hop over-line session") and tokens < real_line:
        hops = Path(args.hops)
        hops.mkdir(parents=True, exist_ok=True)
        latch = hops / f"fired-{sid or 'nosession'}"
        if not latch.exists():
            latch.write_text(f"refuse-recurse/{tokens}/{line}\n")
            os.chmod(latch, 0o600)
        print("refuse: hop foot under real grok line", file=sys.stderr)
        return 0
    hops = Path(args.hops)
    hops.mkdir(parents=True, exist_ok=True)
    pending = hops / "hop-80-pending.md"
    pending.write_text(
        f"hop80\nsession: {sid}\nprompt_tokens: {tokens}\nline: {line}\nwindow: {window}\n"
    )
    os.chmod(pending, 0o600)
    print(f"hop80 {tokens}/{line}")
    latch = hops / f"fired-{sid or 'nosession'}"
    if latch.exists() and args.fake_tokens is None and not args.dry_run:
        print(f"latched {latch}", file=sys.stderr)
        return 0
    if args.dry_run:
        scope = _scope()
        if scope is None:
            print("hop80 detected, no hop-scope.sh", file=sys.stderr)
            return 0
        goal = "Hop this over-line session. The 80 percent trigger must fire."
        trim = (
            f"Uncompressed session at {tokens}/{line}. "
            f"Working task: {goal} Compression stays off. Close this donor by address."
        )
        packet = subprocess.run(
            [str(scope), "--goal", goal, "--edge", "head", "--leave",
             "--in-scope", str(pending),
             "--out-of-scope", "talk to the donor",
             "--constraint", "compression.enabled stays false",
             "--trim", trim],
            text=True, capture_output=True,
        )
        if packet.returncode != 0:
            sys.stderr.write(packet.stderr or packet.stdout)
            return packet.returncode or 6
        sys.stdout.write(packet.stdout)
        return 0
    sender = _sender()
    if sender is None:
        print("hop80 detected, no sender", file=sys.stderr)
        return 0
    scope = _scope()
    if scope is None:
        print("hop80 detected, no hop-scope.sh", file=sys.stderr)
        return 0
    goal = "Hop this over-line session. The 80 percent trigger must fire."
    trim = (
        f"Uncompressed session at {tokens}/{line}. "
        f"Working task: {goal} Compression stays off. Close this donor by address."
    )
    packet = subprocess.run(
        [str(scope), "--goal", goal, "--edge", "head", "--leave",
         "--in-scope", str(pending),
         "--out-of-scope", "talk to the donor",
         "--constraint", "compression.enabled stays false",
         "--trim", trim],
        text=True, capture_output=True,
    )
    if packet.returncode != 0:
        sys.stderr.write(packet.stderr or packet.stdout)
        return packet.returncode or 6
    sent = subprocess.run([str(sender)], input=packet.stdout, text=True)
    if sent.returncode == 0:
        latch.write_text(f"{tokens}/{line}\n")
        os.chmod(latch, 0o600)
    return sent.returncode


def _scope() -> Path | None:
    here = Path(__file__).resolve().parent
    p = here / "hop-scope.sh"
    if p.is_file() and os.access(p, os.X_OK):
        return p
    return None


def _sender() -> Path | None:
    env = os.environ.get("HOP_SEND", "").strip()
    if env:
        p = Path(env)
        return p if p.is_file() else None
    here = Path(__file__).resolve().parent
    # Sender beside this script. Never a hardcoded foreign toolbox.
    if sys.platform == "darwin":
        mac = here / "mac-hop-send.sh"
        if mac.is_file():
            return mac
    house = here / "hop-send.sh"
    if house.is_file() and os.access(house, os.X_OK):
        return house
    return None


if __name__ == "__main__":
    raise SystemExit(main())
