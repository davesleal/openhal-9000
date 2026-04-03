#!/usr/bin/env bash
# OpenHAL 9000 — Synthesize text and play audio
set -euo pipefail

PORT="${OPENHAL_PORT:-9090}"
TEXT="${*}"

if [ -z "$TEXT" ]; then
  TEXT=$(cat 2>/dev/null || true)
fi

if [ -z "$TEXT" ]; then
  exit 0
fi

TMPWAV=$(mktemp /tmp/hal-XXXXXX.wav)
trap 'rm -f "$TMPWAV"' EXIT

# Synthesize via TCP to persistent server
python3 -c "
import socket, sys
s = socket.socket()
s.settimeout(10)
try:
    s.connect(('localhost', ${PORT}))
except (ConnectionRefusedError, OSError):
    sys.exit(1)
s.sendall(sys.argv[1].encode() + b'\n')
s.shutdown(socket.SHUT_WR)
data = b''
while True:
    chunk = s.recv(65536)
    if not chunk: break
    data += chunk
s.close()
sys.stdout.buffer.write(data)
" "$TEXT" 2>/dev/null | ffmpeg -y -f s16le -ar 22050 -ac 1 -i pipe:0 \
  -af "anlmdn=s=0.01,agate=threshold=0.02:ratio=3:attack=5:release=50,highpass=f=120,lowpass=f=6500,equalizer=f=3500:t=q:w=1:g=-1,compand=points=-80/-80|-20/-20:attacks=0.005:decays=0.1" \
  -acodec pcm_s16le -ar 22050 "$TMPWAV" 2>/dev/null || exit 0

# Platform-specific playback
if command -v afplay >/dev/null 2>&1; then
  afplay "$TMPWAV"
elif command -v paplay >/dev/null 2>&1; then
  paplay "$TMPWAV"
elif command -v aplay >/dev/null 2>&1; then
  aplay "$TMPWAV"
fi
