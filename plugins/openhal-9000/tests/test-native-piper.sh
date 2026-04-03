#!/usr/bin/env bash
# OpenHAL 9000 — Test suite for native Piper setup
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DATA_DIR="$HOME/.openhal-9000"
PASS=0
FAIL=0

pass() { echo "  PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL + 1)); }

echo "=== OpenHAL 9000 Test Suite ==="
echo ""

# --- Prerequisites ---
echo "[Prerequisites]"

if command -v python3 >/dev/null 2>&1; then
  pass "python3 is installed"
else
  fail "python3 is not installed"
fi

if command -v afplay >/dev/null 2>&1; then
  pass "afplay is available"
else
  fail "afplay is not available (non-macOS?)"
fi

# --- Venv & Piper ---
echo ""
echo "[Piper Installation]"

if [ -d "$DATA_DIR/venv" ]; then
  pass "venv directory exists"
else
  fail "venv directory missing at $DATA_DIR/venv"
fi

if [ -f "$DATA_DIR/venv/bin/piper" ]; then
  pass "piper binary exists in venv"
else
  fail "piper binary not found in venv"
fi

if "$DATA_DIR/venv/bin/piper" --help >/dev/null 2>&1; then
  pass "piper binary is executable"
else
  fail "piper binary is not executable"
fi

# --- Model ---
echo ""
echo "[Voice Model]"

if [ -f "$DATA_DIR/models/hal.onnx" ] || [ -L "$DATA_DIR/models/hal.onnx" ]; then
  pass "hal.onnx model exists"
else
  fail "hal.onnx model not found"
fi

if [ -f "$DATA_DIR/models/hal.onnx.json" ] || [ -L "$DATA_DIR/models/hal.onnx.json" ]; then
  pass "hal.onnx.json config exists"
else
  fail "hal.onnx.json config not found"
fi

MODEL_SIZE=$(stat -f%z "$DATA_DIR/models/hal.onnx" 2>/dev/null || echo "0")
if [ "$MODEL_SIZE" -gt 1000000 ]; then
  pass "model file is >1MB ($MODEL_SIZE bytes)"
else
  fail "model file suspiciously small ($MODEL_SIZE bytes)"
fi

# --- Scripts ---
echo ""
echo "[Scripts]"

for script in hal-speak.sh hal-setup.sh hal-start.sh hal-health.sh; do
  if [ -f "$PLUGIN_ROOT/scripts/$script" ]; then
    pass "$script exists"
  else
    fail "$script missing"
  fi
done

# Check scripts don't reference Docker as required
for script in hal-speak.sh hal-start.sh; do
  if grep -q "docker" "$PLUGIN_ROOT/scripts/$script" 2>/dev/null; then
    fail "$script still references Docker"
  else
    pass "$script has no Docker dependency"
  fi
done

# Check speak script references native piper
if grep -q "venv/bin/piper" "$PLUGIN_ROOT/scripts/hal-speak.sh" 2>/dev/null; then
  pass "hal-speak.sh uses native piper"
else
  fail "hal-speak.sh does not reference native piper"
fi

# Check speak script doesn't reference ffmpeg
if grep -q "ffmpeg" "$PLUGIN_ROOT/scripts/hal-speak.sh" 2>/dev/null; then
  fail "hal-speak.sh still references ffmpeg"
else
  pass "hal-speak.sh has no ffmpeg dependency"
fi

# --- Synthesis Test ---
echo ""
echo "[Synthesis]"

TMPWAV=$(mktemp /tmp/hal-test-XXXXXXXX.wav)
trap 'rm -f "$TMPWAV"' EXIT

START=$(python3 -c "import time; print(time.time())")
echo "Test." | "$DATA_DIR/venv/bin/piper" --model "$DATA_DIR/models/hal.onnx" \
  --output_file "$TMPWAV" --length_scale 0.92 2>/dev/null
END=$(python3 -c "import time; print(time.time())")

if [ -f "$TMPWAV" ] && [ "$(stat -f%z "$TMPWAV" 2>/dev/null || echo 0)" -gt 100 ]; then
  pass "synthesis produced audio output"
else
  fail "synthesis produced no output"
fi

DURATION=$(python3 -c "print(f'{$END - $START:.2f}')")
if python3 -c "exit(0 if $END - $START < 3.0 else 1)"; then
  pass "synthesis completed in ${DURATION}s (<3s)"
else
  fail "synthesis took ${DURATION}s (>3s — may be too slow)"
fi

# --- hal-speak.sh integration ---
echo ""
echo "[Integration]"

if bash "$PLUGIN_ROOT/scripts/hal-start.sh" 2>/dev/null; then
  pass "hal-start.sh passes verification"
else
  fail "hal-start.sh verification failed"
fi

health_output=$(bash "$PLUGIN_ROOT/scripts/hal-health.sh" 2>&1 || true)
if echo "$health_output" | grep -q "Piper: installed"; then
  pass "hal-health.sh reports Piper installed"
else
  fail "hal-health.sh does not report Piper installed"
fi

# --- README ---
echo ""
echo "[Documentation]"

if grep -q "Python 3" "$PLUGIN_ROOT/README.md" 2>/dev/null; then
  pass "README lists Python 3 as requirement"
else
  fail "README missing Python 3 requirement"
fi

if grep -q "Apple Silicon" "$PLUGIN_ROOT/README.md" 2>/dev/null; then
  pass "README mentions Apple Silicon"
else
  fail "README missing Apple Silicon reference"
fi

if grep -q "Docker Fallback" "$PLUGIN_ROOT/README.md" 2>/dev/null; then
  pass "README includes Docker fallback section"
else
  fail "README missing Docker fallback section"
fi

if grep -q "OPENHAL_LENGTH_SCALE" "$PLUGIN_ROOT/README.md" 2>/dev/null; then
  pass "README documents OPENHAL_LENGTH_SCALE"
else
  fail "README missing OPENHAL_LENGTH_SCALE documentation"
fi

# --- Summary ---
echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
exit $FAIL
