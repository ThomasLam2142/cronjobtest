# Cronjob Test — version-controlled cron job demo

Bare-concept demo: a Hermes cron job whose behavior lives in this git repo.
Every tick the job **pulls the latest commit**, then runs whatever
[`tick.md`](tick.md) says. **Push a change to `tick.md` and the next tick
runs your new instructions** — no need to touch the cron job itself.

## How it works

```
git push (anywhere)  →  origin/main  →  cron tick:
   1. bash scripts/gitpull.sh      # git pull --autostash --ff-only
   2. read tick.md                 # the version-controlled task
   3. follow tick.md               # result written to output/last_run.md (gitignored)
```

The cron job's own prompt (what lives in `jobs.json`) is the thin bootstrap
in [`cron/prompt.md`](cron/prompt.md): pull, read `tick.md`, follow it. All
iteration happens in this repo.

## Files

| File | Role |
|---|---|
| `tick.md` | **The task.** Edit this, commit, push → next tick runs it |
| `cron/prompt.md` | Bootstrap prompt installed into the cron job (version-controlled spec) |
| `scripts/gitpull.sh` | The git pull logic, version-controlled with the repo |
| `scripts/setup_cron.sh` | Creates the cron job from this repo (idempotence guard included) |
| `output/last_run.md` | Each tick's summary (gitignored) |

## Commands

```bash
# Create the job (schedule default 15m; override: bash scripts/setup_cron.sh "30m")
bash scripts/setup_cron.sh

# Trigger one run immediately (async)
hermes cron run cronjobtest-tick

# Watch results
cat output/last_run.md

# Update the job if you change cron/prompt.md
hermes cron edit cronjobtest-tick --prompt "$(cat cron/prompt.md)"

# Remove
hermes cron remove cronjobtest-tick
```

Job: `cronjobtest-tick` · model `meituan/longcat-2.0` (nous) · workdir = this repo.
