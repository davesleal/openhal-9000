# OpenHAL 9000 — Current State

**Last updated:** 2026-04-03

## Architecture

Native Piper TTS on Apple Silicon. No Docker required (kept as fallback).

```
Claude Code → hal-speak.sh → ~/.openhal-9000/venv/bin/piper → afplay
```

## Voice Pipeline

| Component | Implementation |
|-----------|---------------|
| TTS Engine | Piper TTS (native, venv) |
| Voice Model | campwill/HAL-9000-Piper-TTS (63MB ONNX) |
| Speech Rate | 0.92 length_scale |
| Audio Format | WAV (22050 Hz, 16-bit, mono) |
| Playback | afplay (macOS) |
| Buffering | Double-buffer (synth N+1 while playing N) |

## Performance

| Metric | Value |
|--------|-------|
| Synthesis per sentence | ~0.7s (native) |
| Docker overhead | ~37% slower (fallback only) |
| Model load | First-call only (~1s) |

## What's Working

- Native Piper synthesis on Apple Silicon
- Double-buffered playback in shell functions
- Session-start hook with auto-setup
- HAL mode toggle with status line indicator
- Docker fallback with error handling
- Test suite (24 tests)

## Roadmap

- Landing page / website
- Plugin marketplace listing
- Explore Apple Neural Engine / CoreML backend for faster inference
- Linux native support (paplay/aplay)
