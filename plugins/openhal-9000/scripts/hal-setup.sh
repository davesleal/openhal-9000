#!/usr/bin/env bash
# OpenHAL 9000 — First-run bootstrap
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DATA_DIR="$HOME/.openhal-9000"
MODEL_DIR="$DATA_DIR/models"
MODEL_FILE="$MODEL_DIR/hal.onnx"
MODEL_JSON="$MODEL_DIR/hal.onnx.json"
VENV_DIR="$DATA_DIR/venv"

# Known-good checksums
MODEL_SHA256="0e08c82dc027bc72b8b839324801709e205e8c201ccae171b92e37a664d94361"

# HuggingFace URLs
HF_BASE="https://huggingface.co/campwill/HAL-9000-Piper-TTS/resolve/main"
MODEL_URL="${HF_BASE}/hal.onnx"
CONFIG_URL="${HF_BASE}/hal.onnx.json"

# --- Check prerequisites ---
if ! command -v python3 >/dev/null 2>&1; then
  echo "ERROR: Python 3 is required. Install with: brew install python" >&2
  exit 1
fi

# --- Create data directory ---
mkdir -p "$MODEL_DIR"
chmod 700 "$DATA_DIR"

# --- Download or link model ---
if [ ! -f "$MODEL_FILE" ] && [ ! -L "$MODEL_FILE" ]; then
  # Check if user already has the model from a previous manual install
  if [ -f "$HOME/.piper/models/hal.onnx" ]; then
    echo "Found existing HAL model in ~/.piper/models/. Copying it."
    cp "$HOME/.piper/models/hal.onnx" "$MODEL_FILE"
    cp "$HOME/.piper/models/hal.onnx.json" "$MODEL_JSON"
  else
    echo "Downloading HAL 9000 voice model (~63MB)..."
    if ! curl -fL --progress-bar -o "$MODEL_FILE" "$MODEL_URL"; then
      echo "ERROR: Failed to download model. Check your internet connection and try /hal setup again." >&2
      rm -f "$MODEL_FILE"
      exit 1
    fi
    if ! curl -fL --progress-bar -o "$MODEL_JSON" "$CONFIG_URL"; then
      echo "ERROR: Failed to download model config." >&2
      rm -f "$MODEL_FILE" "$MODEL_JSON"
      exit 1
    fi
  fi
fi

# --- Verify checksum ---
if command -v shasum >/dev/null 2>&1; then
  TARGET="$MODEL_FILE"
  if [ -L "$MODEL_FILE" ]; then
    TARGET="$(readlink "$MODEL_FILE")"
  fi
  ACTUAL_SHA=$(shasum -a 256 "$TARGET" | awk '{print $1}')
  if [ "$ACTUAL_SHA" != "$MODEL_SHA256" ]; then
    echo "WARNING: Model checksum mismatch. File may be corrupted or updated." >&2
    echo "Expected: $MODEL_SHA256" >&2
    echo "Got:      $ACTUAL_SHA" >&2
  fi
fi

# --- Create Python venv with Piper TTS ---
if [ ! -f "$VENV_DIR/bin/piper" ]; then
  echo "Setting up Piper TTS (native)..."
  python3 -m venv "$VENV_DIR"
  "$VENV_DIR/bin/pip" install --quiet piper-tts
fi

# --- Symlink speak script ---
ln -sf "$PLUGIN_ROOT/scripts/hal-speak.sh" "$DATA_DIR/hal-speak.sh"

# --- Create sentinel files ---
touch "$DATA_DIR/voice-enabled"
touch "$DATA_DIR/initialized"

echo "OpenHAL 9000 setup complete."
