# Leal Labs — Claude Code Plugins

Plugins for Claude Code by [Leal Labs](https://github.com/daveleal).

## Plugins

| Plugin | Description |
|--------|-------------|
| [OpenHAL 9000](plugins/openhal-9000/) | HAL 9000 voice for Claude Code |

## Installation

Add to `~/.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "leal-labs": {
      "source": {
        "source": "github",
        "repo": "daveleal/claude-plugins"
      }
    }
  }
}
```

Then install via `/plugins` in Claude Code.
