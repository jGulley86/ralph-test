#!/bin/bash
# Ralph loop — runs Claude Code against PLAN.md.
# Stops when: (a) max iterations reached, (b) Claude prints "ALL DONE", or (c) Ctrl+C.

set -e

MAX_ITER=10
SLEEP_SECONDS=10
ITER=0

while [ $ITER -lt $MAX_ITER ]; do
  ITER=$((ITER + 1))
  echo ""
  echo "═══════════════════════════════════════"
  echo "  RALPH ITERATION $ITER of $MAX_ITER  —  $(date '+%H:%M:%S')"
  echo "═══════════════════════════════════════"

  OUTPUT=$(claude -p "Read CLAUDE.md and PLAN.md. Pick the next unchecked item in PLAN.md, complete it, mark it [x] when done, then commit and push your changes with a clear message. If every item is checked, print 'ALL DONE' and exit. Do exactly one item per run." \
    --permission-mode bypassPermissions 2>&1 | tee /dev/tty)

  if echo "$OUTPUT" | grep -q "ALL DONE"; then
    echo ""
    echo "═══════════════════════════════════════"
    echo "  PLAN COMPLETE — stopping after $ITER iteration(s)"
    echo "═══════════════════════════════════════"
    exit 0
  fi

  echo ""
  echo "Iteration $ITER complete. Sleeping ${SLEEP_SECONDS}s — Ctrl+C to stop."
  sleep $SLEEP_SECONDS
done

echo ""
echo "═══════════════════════════════════════"
echo "  HIT MAX ITERATIONS ($MAX_ITER) — stopping"
echo "═══════════════════════════════════════"
