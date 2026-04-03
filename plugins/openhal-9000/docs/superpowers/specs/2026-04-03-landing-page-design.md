# OpenHAL 9000 Landing Page — Design Spec

## Overview

A single-page marketing site for the OpenHAL 9000 Claude Code plugin. Visually inspired by the film 2001: A Space Odyssey (1968). Hosted on GitHub Pages as a pure HTML + CSS file with no build step or dependencies.

**Primary goal:** Get developers to install the plugin.
**Secondary goal:** Visually expand on what the GitHub README offers — sell the experience.

## Hosting & Deployment

- **Platform:** GitHub Pages
- **Source:** `/docs/index.html` in the `davesleal/openhal-9000` repo
- **URL:** `davesleal.github.io/openhal-9000`
- **Build step:** None — pure static HTML + inline CSS
- **Cost:** Free

## Visual Direction

A fusion of two 2001 aesthetics:

1. **The HAL Eye** — Dark, centered, menacing. The iconic red eye dominates the hero. Black backgrounds, red accents, minimal text.
2. **Discovery One Clean** — Clinical precision. Monospaced readouts, structured grids, deliberate emptiness. Kubrick's obsessive symmetry.

### Film Reference Elements

| Element | Source | Usage |
|---------|--------|-------|
| HAL 9000 eye in tall narrow housing | Close-up shots of HAL | Hero centerpiece |
| Blue diagnostic screens with monospace data | Bridge CRT displays | Technical specs section |
| Systems operational readouts with colored label bars + waveforms | Life signs monitor | Features/status section |
| Logic Memory Center brushed metal panel | LMC door plate | Features grid section |
| Memory terminal narrow white bars on red | LMC interior | Decorative element beneath features |
| Futura typography | Film signage and labels | Primary typeface throughout |
| Status display readouts | Bridge instruments | Subtle UI details |

## Typography

- **Primary:** Familjen Grotesk (Google Fonts) — geometric grotesque closest to Futura
- **Monospace:** Courier New — for diagnostic screens and code blocks
- **Treatment:** Uppercase with positive letter-spacing for section labels and headers (aerospace stencil voice)
- **Weights:** 400 body, 600 labels, 700 titles

## Color Palette

| Role | Color | Notes |
|------|-------|-------|
| Background | `#000000` | Pure black, the void of space |
| Eye housing | `#2a2a2e` → `#18181c` | Dark gray gradient, lighter than background |
| HAL red | `#cc2222` | Primary accent, label bars, panel fills |
| HAL eye glow | `#ff2200` → `#ffee55` | Radial gradient, red to amber center |
| Blue diagnostic | `#0a1a3a` → `#0d1f42` | CRT screen background |
| Blue text | `rgba(150,200,255,0.7)` | Diagnostic readout text |
| Section labels | `rgba(255,0,0,0.45)` | Uppercase red labels |
| Body text | `rgba(255,255,255,0.5)` | De-emphasized white |
| Ghost button border | `rgba(255,60,60,0.35)` | SpaceX-style ghost CTA |
| Metal panel | `#c0c0c0` → `#b8b8b8` | Brushed metal gradient |

## Page Structure (Single-Page Scroll)

Each section occupies a full viewport (100vh), creating cinematic pacing.

### 1. Hero (100vh)

- **HAL eye** in a tall, narrow housing (taller and narrower than v1 — matching the real film prop's portrait-oriented rectangular panel)
  - Housing: dark gray with subtle gradient, screw details at corners, inset border highlight
  - Small "HAL 9000" status display above the eye in blue monospace
  - Eye: multi-layer radial gradient (red outer → amber pupil), lens rings, specular highlight
- **Play button label:** "▶ CLICK TO HEAR HAL SPEAK" — triggers pre-rendered WAV greeting
  - Greeting text: "Good afternoon, developer. I am OpenHAL 9000. I am here to assist you in your Claude Code journey."
- **Title:** "OPENHAL 9000" in uppercase, wide letter-spacing
- **Tagline:** *"Good afternoon. I am HAL 9000."* in italic
- **CTA:** Ghost button labeled "INSTALL" linking to install section
- **Atmosphere:** Radial gradient background (dark red center fading to black), CRT scan lines overlay

### 2. Systems Operational (100vh)

Directly inspired by the life signs monitor (image 7).

Five horizontal rows, each with:
- **Colored label bar** (left, 200px): system name in uppercase white text
- **Readout area** (right, flex): dark background with colored grid overlay, animated SVG waveform, value text

| Row | Label Color | System | Value |
|-----|-------------|--------|-------|
| 1 | Red | Voice Synthesis | ~0.7s / sentence |
| 2 | Cyan | Neural Engine | Piper ONNX |
| 3 | Red | Audio Pipeline | 22050 Hz WAV |
| 4 | Green | Systems Integration | Claude Code |
| 5 | Amber | Persona Module | HAL 9000 |

### 3. Blue Diagnostic Screen (100vh)

Inspired by the blue CRT displays on Discovery One's bridge (image 3).

- Blue-tinted panel with CRT glow effect and scan lines
- Monospace readout of technical specifications:
  - TTS Engine, Voice Model, Architecture, Sample Rate, Length Scale, Dependencies, Docker status, ffmpeg status
- Blinking cursor at end of last line ("ALL SYSTEMS OPERATIONAL")
- Subtle radial glow and border matching film aesthetic

### 4. Logic Memory Center (100vh)

Inspired by the LMC door plate (image 8) and interior (image 9).

**Metal panel:**
- Brushed metal gradient background with screw details at all four corners
- Header row: "MAXIMUM RESTRICTED ENTRY" | HAL 9000 badge | "LOGIC MEMORY CENTER"
- 2×2 grid of feature cells with red borders, alternating filled (red bg) and empty (metal bg):
  - Native TTS (filled), Zero Config (empty)
  - In Character (empty), Voice Control (filled)

**Memory terminal bars** directly beneath:
- Red background container
- Header: "IV-3 LOGIC TERMINAL" / "MEMORY TERMINAL"
- Row of narrow white vertical modules (LT/1-6 + gap + MT/1-6) with labels and numbers

### 5. Installation Sequence (100vh)

- Section label: "INSTALLATION SEQUENCE"
- Three numbered steps (01, 02, 03):
  1. Add marketplace JSON to settings — shown in blue code block
  2. Run /plugins → install — shown in blue code block
  3. Start new session (text description only, no code block)
- Two ghost buttons at bottom: "GitHub" (primary) and "Documentation" (secondary, muted)

### 6. Footer

- Credit line: "Created by Dave Leal — Leal Labs — MIT License"
- Disclaimer text (very small, muted)

## Interactive Elements

### Voice Greeting (Web Audio API)
- Pre-rendered WAV file (~200KB) of HAL speaking the greeting
- Triggered by clicking the play label or the HAL eye in the hero
- Uses Web Audio API for playback (no `<audio>` element needed)
- File generated offline using Piper TTS with the HAL model

### Smooth Scroll
- Install ghost button smooth-scrolls to the install section
- No other navigation needed (single page)

### Hover States
- Ghost buttons: background brightens, border intensifies, subtle red glow
- Play label: text brightens on hover

## Responsive Behavior

| Breakpoint | Changes |
|------------|---------|
| Desktop (>960px) | Full layout as designed |
| Tablet (640-960px) | Reduce font sizes, narrow panels, maintain full-vh sections |
| Mobile (<640px) | Stack system readout labels above readouts, single-column feature grid, reduce eye housing size |

## Assets Required

1. **HAL greeting WAV** — pre-rendered using Piper TTS (~200KB)
2. **Favicon** — red circle (HAL eye simplified) as SVG favicon

## Files

| File | Purpose |
|------|---------|
| `docs/index.html` | The landing page (HTML + inline CSS + minimal JS) |
| `docs/hal-greeting.wav` | Pre-rendered voice greeting |
| `docs/CNAME` | Custom domain (if added later) |

## Out of Scope

- No JavaScript framework
- No build step or package.json
- No analytics (can be added later)
- No dark/light mode toggle (it's always dark)
- No multi-page navigation
- No cookie banner
