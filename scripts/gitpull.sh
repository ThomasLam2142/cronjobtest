#!/usr/bin/env bash
# Version-controlled pull logic — called by the cron job on every tick.
# Fast-forwards this repo to origin/main, stashing local changes first
# (previous ticks may have left uncommitted files in the working tree).
set -u
cd "$(dirname "$0")/.." || exit 1
git pull --autostash --ff-only 2>&1
