#!/usr/bin/env bash
# Creates the demo cron job from this repo's version-controlled spec.
# Run from anywhere:  bash scripts/setup_cron.sh [schedule]
set -e
cd "$(dirname "$0")/.."

JOB_NAME="cronjobtest-tick"
SCHEDULE="${1:-15m}"   # override: bash scripts/setup_cron.sh "30m"

if hermes cron list 2>/dev/null | grep -q "$JOB_NAME"; then
  echo "Job '$JOB_NAME' already exists. To apply a changed cron/prompt.md:"
  echo "  hermes cron edit $JOB_NAME --prompt \"\$(cat cron/prompt.md)\""
  echo "  (or remove it first: hermes cron remove $JOB_NAME, then re-run this script)"
  exit 1
fi

PROMPT="$(cat cron/prompt.md)"
hermes cron create "$SCHEDULE" "$PROMPT" \
  --name "$JOB_NAME" \
  --model meituan/longcat-2.0 \
  --provider nous \
  --workdir "$(pwd)"

echo
echo "Created '$JOB_NAME' (schedule: $SCHEDULE, model: meituan/longcat-2.0)."
echo "Verify:   hermes cron list"
echo "Trigger:  hermes cron run $JOB_NAME"
echo "Results:  cat output/last_run.md"
