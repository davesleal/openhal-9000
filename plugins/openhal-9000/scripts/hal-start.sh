#!/usr/bin/env bash
# OpenHAL 9000 — Verify native Piper is ready
set -euo pipefail

DATA_DIR="$HOME/.openhal-9000"
PIPER="$DATA_DIR/venv/bin/piper"
MODEL="$DATA_DIR/models/hal.onnx"

# Check Piper is installed
if [ ! -f "$PIPER" ]; then
  echo "ERROR: Piper not found. Run /hal setup to install." >&2
  exit 1
fi

# Check model exists
if [ ! -f "$MODEL" ] && [ ! -L "$MODEL" ]; then
  echo "ERROR: Voice model not found. Run /hal setup to download." >&2
  exit 1
fi

exit 0
