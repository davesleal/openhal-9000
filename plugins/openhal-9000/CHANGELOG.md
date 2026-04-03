# Changelog

## 2026-04-03 — Native Piper TTS

**Breaking:** Docker and ffmpeg are no longer required. Existing Docker
installations will continue to work as a fallback.

### Added
- Native Piper TTS via Python venv (`~/.openhal-9000/venv`)
- `OPENHAL_LENGTH_SCALE` env var for speech rate tuning (default: 0.92)
- System recommendations in README (Apple Silicon, RAM, disk)
- Docker fallback documentation
- Upgrade guide from Docker to native
- Test suite (`tests/test-native-piper.sh`, 24 tests)
- Error handling in setup (curl failures, exit code checks)
- Timeouts and exception handling in Docker fallback server

### Changed
- `hal-speak.sh` calls Piper directly instead of TCP socket + ffmpeg
- `hal-setup.sh` creates venv instead of building Docker image
- `hal-start.sh` verifies native installation instead of managing containers
- `hal-health.sh` reports native Piper status
- Speech rate set to 0.92 (from 1.0)

### Removed
- Docker as a default requirement (kept as opt-in fallback)
- ffmpeg dependency
- TCP socket communication for synthesis

### Fixed
- `$*` unbound variable crash in `hal-speak.sh` when using piped input
- Session-start hook now checks exit codes from setup/verification

## 2026-04-02 — Speak First

### Changed
- HAL speaks at the start of every response, not the end
- Audio filters added to `hal-speak.sh` (denoise, gate, EQ, compression)

## 2026-04-01 — Initial Release

### Added
- HAL 9000 voice for Claude Code via Piper TTS in Docker
- Session-start hook with first-run bootstrap
- `/hal` command (mode, on, off, say, status, restart, setup)
- Status line indicator (red orb)
- Voice model auto-download from HuggingFace
- Checksum verification for model integrity
