#!/usr/bin/env bash
# OpenHAL 9000 — Synthesize text and play audio (native Piper)
set -euo pipefail

DATA_DIR="$HOME/.openhal-9000"
PIPER="$DATA_DIR/venv/bin/piper"
MODEL="$DATA_DIR/models/hal.onnx"
LENGTH_SCALE="${OPENHAL_LENGTH_SCALE:-0.92}"
TEXT="${*:-}"

if [ -z "$TEXT" ]; then
  TEXT=$(cat 2>/dev/null || true)
fi

if [ -z "$TEXT" ]; then
  exit 0
fi

TMPWAV=$(mktemp /tmp/hal-XXXXXX.wav)
trap 'rm -f "$TMPWAV"' EXIT

echo "$TEXT" | "$PIPER" --model "$MODEL" --output_file "$TMPWAV" \
  --length_scale "$LENGTH_SCALE" 2>/dev/null || exit 0

# Platform-specific playback
if command -v afplay >/dev/null 2>&1; then
  afplay "$TMPWAV"
elif command -v paplay >/dev/null 2>&1; then
  paplay "$TMPWAV"
elif command -v aplay >/dev/null 2>&1; then
  aplay "$TMPWAV"
fi
