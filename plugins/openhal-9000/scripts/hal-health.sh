#!/usr/bin/env bash
# OpenHAL 9000 — Health check
DATA_DIR="$HOME/.openhal-9000"
PIPER="$DATA_DIR/venv/bin/piper"

echo "=== OpenHAL 9000 Status ==="

# Piper
if [ -f "$PIPER" ]; then
  echo "Piper: installed (native)"
else
  echo "Piper: NOT INSTALLED"
fi

# Model
if [ -f "$DATA_DIR/models/hal.onnx" ] || [ -L "$DATA_DIR/models/hal.onnx" ]; then
  TARGET="$DATA_DIR/models/hal.onnx"
  [ -L "$TARGET" ] && TARGET="$(readlink "$TARGET")"
  SIZE=$(du -h "$TARGET" 2>/dev/null | cut -f1)
  echo "Model: present ($SIZE)"
else
  echo "Model: NOT FOUND"
fi

# Voice toggle
if [ -f "$DATA_DIR/voice-enabled" ]; then
  echo "Voice: enabled"
else
  echo "Voice: disabled"
fi

# HAL mode
if [ -f "$DATA_DIR/hal-mode" ]; then
  echo "HAL Mode: active"
else
  echo "HAL Mode: inactive"
fi

# Python
if command -v python3 >/dev/null 2>&1; then
  echo "Python: $(python3 --version 2>&1)"
else
  echo "Python: NOT INSTALLED"
fi
