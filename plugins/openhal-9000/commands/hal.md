---
description: Control HAL 9000 voice — mode, on, off, say, status, restart, setup
argument-hint: <mode|on|off|say|status|restart|setup> [text]
allowed-tools: [Bash, Read]
---

# HAL Voice Control

Parse the user's argument from: $ARGUMENTS

## Commands

### `mode`
Toggle HAL mode (always-on voice + status orb):

```bash
if [ -f ~/.openhal-9000/hal-mode ]; then
  rm -f ~/.openhal-9000/hal-mode
  bash ~/.openhal-9000/hal-speak.sh "HAL mode disengaged. Goodbye for now, Dave."
else
  touch ~/.openhal-9000/hal-mode
  touch ~/.openhal-9000/voice-enabled
  bash ~/.openhal-9000/hal-speak.sh "HAL mode engaged. I am listening, Dave."
fi
```

Tell the user HAL mode is now on or off.

### `on` or `unmute`
Enable voice:
```bash
touch ~/.openhal-9000/voice-enabled
bash ~/.openhal-9000/hal-speak.sh "Voice systems online, Dave."
```

### `off` or `mute`
Disable voice:
```bash
rm -f ~/.openhal-9000/voice-enabled
```
Confirm in text only. Do NOT call hal-speak.sh.

### `say`
Speak the text after "say". Extract the text from the arguments (everything after "say"):
```bash
bash ~/.openhal-9000/hal-speak.sh "the extracted text"
```

### `status`
Run health check:
```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/hal-health.sh"
```
Report the output to the user.

### `restart`
Restart the TTS server:
```bash
docker rm -f openhal-9000-server 2>/dev/null
bash "${CLAUDE_PLUGIN_ROOT}/scripts/hal-start.sh"
bash ~/.openhal-9000/hal-speak.sh "HAL 9000 systems restarted. All operational."
```

### `setup`
Re-run first-time setup:
```bash
rm -f ~/.openhal-9000/initialized
bash "${CLAUDE_PLUGIN_ROOT}/scripts/hal-setup.sh"
```

### No arguments or `help`
Show available commands:
- `/hal mode` — Toggle always-on voice + red orb status
- `/hal on` / `/hal off` — Enable/disable voice
- `/hal say "text"` — Speak text as HAL
- `/hal status` — Check system health
- `/hal restart` — Restart TTS server
- `/hal setup` — Re-run first-time setup
