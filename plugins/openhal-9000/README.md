# OpenHAL 9000

> *"Good afternoon. I am HAL 9000."*

A Claude Code plugin that gives Claude a voice — specifically, the voice of
HAL 9000. Claude speaks responses aloud using [Piper TTS](https://github.com/rhasspy/piper)
with a HAL 9000 voice model, running natively on your machine.

HAL doesn't just read text. He editorializes. He summarizes. He stays in
character. Calm, precise, politely unsettling.

## Requirements

- **macOS** on Apple Silicon (M1 or later)
- **Python 3.10+** (`brew install python` if needed)
- **Claude Code** (CLI, desktop app, or IDE extension)

That's it. No Docker, no ffmpeg, no external servers.

## System Recommendations

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| Chip | Apple M1 | M1 Pro or later |
| RAM | 8 GB | 16 GB |
| Disk | ~200 MB (model + venv) | — |
| macOS | 14 Sonoma | 15 Sequoia or later |

Piper runs inference on the CPU via ONNX Runtime. Apple Silicon handles it
well — expect ~0.7s synthesis time per sentence on M1 Pro or better.
Machines with more performance cores will synthesize faster.

## Installation

1. Add the marketplace to your Claude Code settings (`~/.claude/settings.json`):

```json
{
  "extraKnownMarketplaces": {
    "leal-labs": {
      "source": {
        "source": "github",
        "repo": "davesleal/openhal-9000"
      }
    }
  }
}
```

2. In Claude Code, run `/plugins` and install **openhal-9000**.

3. Start a new session. On first run, HAL will:
   - Create a Python virtual environment with Piper TTS
   - Download the voice model (~63MB)
   - Sing you a song
   - Introduce himself

## Usage

| Command | Description |
|---------|-------------|
| `/hal mode` | Toggle always-on voice + red status orb |
| `/hal on` | Enable voice |
| `/hal off` | Disable voice |
| `/hal say "text"` | Speak text as HAL |
| `/hal status` | Check system health |
| `/hal restart` | Re-verify Piper installation |
| `/hal setup` | Re-run first-time setup |

## Configuration

| Env Variable | Default | Description |
|-------------|---------|-------------|
| `OPENHAL_LENGTH_SCALE` | `0.92` | Speech rate (lower = faster, 1.0 = default) |

## How It Works

1. A Python venv at `~/.openhal-9000/venv` contains Piper TTS and its dependencies
2. A Claude Code skill instructs Claude to speak at the end of every response
3. Claude calls `hal-speak.sh` which runs Piper natively to synthesize audio
4. macOS `afplay` plays the resulting WAV file

No Docker containers, no network servers, no ffmpeg. Just a direct call to
Piper on Apple Silicon.

## Docker Fallback

If you can't run Piper natively (e.g., Intel Mac, Linux without ONNX Runtime
support), a Docker-based fallback is included:

1. Install [Docker](https://www.docker.com) or [OrbStack](https://orbstack.dev)
2. Build the image: `docker build -t openhal-9000-piper /path/to/plugin`
3. Run the server:
   ```bash
   docker run -d --name openhal-9000-server \
     -p 127.0.0.1:9090:9090 \
     -v ~/.openhal-9000/models:/models \
     openhal-9000-piper
   ```

The Docker server listens on TCP port 9090 and accepts text, returning raw
s16le audio. This is slower than native (~37% overhead from Docker networking)
but works on any platform Docker supports.

## Upgrading from Docker

If you previously used the Docker-based version:

1. Update the plugin (it will auto-setup the native venv on next session start)
2. Optionally clean up the old Docker resources:
   ```bash
   docker rm -f openhal-9000-server
   docker rmi openhal-9000-piper piper-hal-arm
   ```

## Disclaimer

This project is an independent, open-source experiment created for educational
and entertainment purposes. It is not affiliated with, endorsed by, or
sponsored by MGM, Warner Bros., Amazon, the Arthur C. Clarke estate, or any
rights holders of "2001: A Space Odyssey."

Any references to fictional characters, films, or cultural works are made
under principles of fair use for the purpose of commentary, homage, and
interoperability research. This project is non-commercial and generates no
revenue.

THE SOFTWARE IS PROVIDED "AS IS," WITHOUT WARRANTY OF ANY KIND. The author
assumes no liability for legal claims arising from the use of this software.
If you are a rights holder and have concerns, please open an issue or contact
the author directly.

### Security Notice

This plugin runs shell scripts on your machine and creates a local Python
virtual environment. It downloads a third-party machine learning model from
HuggingFace. Review the source code before installing. Only install from the
official repository.

### Voice Model

The TTS voice model is hosted on HuggingFace
([campwill/HAL-9000-Piper-TTS](https://huggingface.co/campwill/HAL-9000-Piper-TTS))
and was created by a third-party contributor. It is not included in this
repository. Check the model's repository for its licensing terms.

## License

[MIT](LICENSE)

## Credits

Created by [Dave Leal](https://github.com/davesleal) / Leal Labs.

Built with [Piper TTS](https://github.com/rhasspy/piper) by Michael Hansen.

Voice model by [campwill](https://huggingface.co/campwill/HAL-9000-Piper-TTS).
