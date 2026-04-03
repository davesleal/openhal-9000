# OpenHAL 9000 Landing Page Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a single-page marketing site for OpenHAL 9000 inspired by 2001: A Space Odyssey, hosted on GitHub Pages.

**Architecture:** One `index.html` file with inline CSS and minimal inline JS. No build step, no dependencies, no framework. A pre-rendered WAV file provides the HAL voice greeting. Deployed via GitHub Pages from the `/docs` directory.

**Tech Stack:** HTML5, CSS3 (inline), vanilla JS (Web Audio API), GitHub Pages

**Spec:** `docs/superpowers/specs/2026-04-03-landing-page-design.md`

---

## File Map

| File | Responsibility |
|------|---------------|
| `docs/index.html` | Complete landing page — HTML structure, inline `<style>`, inline `<script>` for voice playback and smooth scroll |
| `docs/hal-greeting.wav` | Pre-rendered HAL voice greeting (~200KB) |

---

### Task 1: Generate the HAL Voice Greeting WAV

The greeting WAV must exist before the page can reference it. Generate it using the existing Piper TTS installation.

**Files:**
- Create: `docs/hal-greeting.wav`

- [ ] **Step 1: Generate the WAV file using Piper**

```bash
echo "Good afternoon, developer. I am OpenHAL 9000. I am here to assist you in your Claude Code journey." | \
  ~/.openhal-9000/venv/bin/piper \
    --model ~/.openhal-9000/models/hal.onnx \
    --output_file /Users/daveleal/Projects/claude-plugins/plugins/openhal-9000/docs/hal-greeting.wav \
    --length_scale 0.92
```

- [ ] **Step 2: Verify the file was created and is a valid WAV**

```bash
file docs/hal-greeting.wav
# Expected: RIFF (little-endian) data, WAVE audio, Microsoft PCM, 16 bit, mono 22050 Hz

ls -lh docs/hal-greeting.wav
# Expected: ~100-300KB file
```

- [ ] **Step 3: Play it back to verify quality**

```bash
afplay docs/hal-greeting.wav
```

Listen and confirm it sounds correct. If it sounds wrong, adjust the text and re-generate.

- [ ] **Step 4: Commit**

```bash
git add docs/hal-greeting.wav
git commit -m "feat: add HAL voice greeting WAV for landing page"
```

---

### Task 2: Create the Landing Page — HTML Structure and Hero Section

Build the complete HTML document with the `<head>`, Google Fonts import, and the hero section with the HAL eye in its tall narrow housing.

**Files:**
- Create: `docs/index.html`

- [ ] **Step 1: Create `docs/index.html` with document head and hero HTML**

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>OpenHAL 9000 — Give Claude a Voice</title>
  <meta name="description" content="A Claude Code plugin that gives your AI the voice of HAL 9000. Native Piper TTS on Apple Silicon.">
  <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><circle cx='50' cy='50' r='45' fill='%23cc2222'/><circle cx='50' cy='50' r='15' fill='%23ffbb00'/></svg>">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Familjen+Grotesk:wght@400;600;700&display=swap" rel="stylesheet">
  <style>
    /* CSS goes here — added in Task 3 */
  </style>
</head>
<body>

  <!-- HERO -->
  <section class="hero" id="top">
    <div class="hal-eye-housing">
      <div class="hal-status-display">HAL 9000</div>
      <div class="hal-eye">
        <div class="hal-eye-outer"></div>
        <div class="hal-eye-ring"></div>
        <div class="hal-eye-ring2"></div>
        <div class="hal-eye-inner"></div>
        <div class="hal-eye-spec"></div>
      </div>
      <div class="screw tl"></div>
      <div class="screw tr"></div>
      <div class="screw bl"></div>
      <div class="screw br"></div>
    </div>
    <button class="hal-play-label" id="hal-play" aria-label="Play HAL 9000 greeting">&#9654; Click to hear HAL speak</button>
    <h1 class="hero-title">OpenHAL 9000</h1>
    <p class="hero-tagline">"Good afternoon. I am HAL 9000."</p>
    <a href="#install" class="ghost-btn">Install</a>
  </section>

  <div class="red-line"></div>

  <!-- Remaining sections added in Task 4 -->

</body>
</html>
```

- [ ] **Step 2: Open in browser to verify HTML loads**

```bash
open docs/index.html
```

Expected: unstyled HTML content visible in browser. No errors in console.

- [ ] **Step 3: Commit**

```bash
git add docs/index.html
git commit -m "feat: landing page HTML structure and hero section"
```

---

### Task 3: Add All CSS Styles

Add the complete inline `<style>` block covering every section: hero, HAL eye (tall narrow housing), systems operational, blue diagnostic screen, Logic Memory Center, memory terminal bars, install section, footer, responsive breakpoints, and animations.

**Files:**
- Modify: `docs/index.html` — replace the `<style>` placeholder

- [ ] **Step 1: Replace the `<style>` block with the complete CSS**

Replace `/* CSS goes here — added in Task 3 */` with the full stylesheet. Key design tokens:

```css
/* === RESET & BASE === */
* { margin: 0; padding: 0; box-sizing: border-box; }
body {
  background: #000;
  color: #e0e0e0;
  font-family: 'Familjen Grotesk', 'Futura', 'Avenir Next', sans-serif;
  line-height: 1.6;
  overflow-x: hidden;
}

/* === HERO === */
.hero {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: radial-gradient(ellipse at center, #1a0505 0%, #0d0202 35%, #000 75%);
  position: relative;
}
/* CRT scan lines */
.hero::before {
  content: '';
  position: absolute;
  inset: 0;
  background: repeating-linear-gradient(0deg, transparent, transparent 3px, rgba(0,0,0,0.08) 3px, rgba(0,0,0,0.08) 6px);
  pointer-events: none;
  z-index: 1;
}
.hero > * { position: relative; z-index: 2; }

/* === HAL EYE — Tall narrow housing === */
.hal-eye-housing {
  width: 180px;        /* narrower */
  height: 340px;       /* taller — portrait oriented like the film prop */
  background: linear-gradient(180deg, #2e2e32 0%, #242428 40%, #1e1e22 70%, #1a1a1e 100%);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  margin-bottom: 48px;
  cursor: pointer;
  box-shadow:
    inset 0 1px 0 rgba(255,255,255,0.1),
    inset 0 -1px 0 rgba(0,0,0,0.3),
    0 0 80px rgba(255,0,0,0.12),
    0 20px 60px rgba(0,0,0,0.6);
  border: 1px solid rgba(255,255,255,0.06);
}
/* Top highlight */
.hal-eye-housing::before {
  content: '';
  position: absolute;
  left: 0; right: 0; top: 0;
  height: 50px;
  background: linear-gradient(180deg, rgba(255,255,255,0.04), transparent);
  border-radius: 8px 8px 0 0;
  pointer-events: none;
}
.hal-status-display {
  position: absolute;
  top: 24px;
  font-family: 'Courier New', monospace;
  font-size: 9px;
  letter-spacing: 2px;
  color: rgba(100,200,255,0.5);
  background: rgba(0,20,40,0.6);
  padding: 3px 10px;
  border: 1px solid rgba(100,200,255,0.15);
}
.hal-eye {
  width: 140px;
  height: 140px;
  position: relative;
}
.hal-eye-outer {
  position: absolute;
  inset: 0;
  border-radius: 50%;
  background: radial-gradient(circle at 45% 45%, #ff2200 0%, #dd1100 12%, #aa0800 22%, #660000 38%, #330000 52%, #1a1a1a 68%, #111 100%);
  box-shadow: 0 0 60px rgba(255,0,0,0.35), 0 0 120px rgba(255,0,0,0.15), inset 0 0 60px rgba(0,0,0,0.6);
}
.hal-eye-ring {
  position: absolute;
  inset: 5px;
  border-radius: 50%;
  border: 1px solid rgba(255,255,255,0.07);
  box-shadow: inset 0 0 20px rgba(0,0,0,0.3);
}
.hal-eye-ring2 {
  position: absolute;
  inset: 15px;
  border-radius: 50%;
  border: 1px solid rgba(255,255,255,0.04);
}
.hal-eye-inner {
  position: absolute;
  top: 50%; left: 50%;
  transform: translate(-50%, -50%);
  width: 28px; height: 28px;
  border-radius: 50%;
  background: radial-gradient(circle at 40% 40%, #ffee55 0%, #ffbb00 25%, #ff7700 50%, #dd2200 100%);
  box-shadow: 0 0 20px rgba(255,200,0,0.5), 0 0 40px rgba(255,100,0,0.25);
}
.hal-eye-spec {
  position: absolute;
  top: 32%; left: 38%;
  width: 8px; height: 6px;
  border-radius: 50%;
  background: rgba(255,255,255,0.25);
  filter: blur(2px);
}
.screw {
  position: absolute;
  width: 10px; height: 10px;
  border-radius: 50%;
  background: radial-gradient(circle at 35% 35%, #aaa, #777);
  box-shadow: inset 0 1px 2px rgba(0,0,0,0.4), 0 1px 0 rgba(255,255,255,0.3);
}
.screw::after {
  content: '';
  position: absolute;
  top: 50%; left: 50%;
  transform: translate(-50%,-50%) rotate(35deg);
  width: 6px; height: 1px;
  background: rgba(0,0,0,0.3);
}
.screw.tl { top: 14px; left: 14px; }
.screw.tr { top: 14px; right: 14px; }
.screw.bl { bottom: 14px; left: 14px; }
.screw.br { bottom: 14px; right: 14px; }

/* Play label */
.hal-play-label {
  font-family: 'Familjen Grotesk', 'Futura', sans-serif;
  font-size: 10px;
  letter-spacing: 3px;
  color: rgba(255,100,100,0.35);
  text-transform: uppercase;
  cursor: pointer;
  background: none;
  border: none;
  transition: color 0.3s;
  margin-bottom: 48px;
}
.hal-play-label:hover { color: rgba(255,100,100,0.7); }

/* Title and tagline */
.hero-title {
  font-size: 42px;
  font-weight: 700;
  letter-spacing: 14px;
  text-transform: uppercase;
  color: #fff;
  margin-bottom: 16px;
  text-align: center;
}
.hero-tagline {
  font-style: italic;
  color: rgba(255,255,255,0.35);
  font-size: 17px;
  margin-bottom: 48px;
  letter-spacing: 1px;
}

/* Ghost button */
.ghost-btn {
  display: inline-block;
  padding: 16px 44px;
  border: 1px solid rgba(255,60,60,0.35);
  background: rgba(255,0,0,0.06);
  color: #ff4444;
  font-family: 'Familjen Grotesk', 'Futura', sans-serif;
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 5px;
  text-transform: uppercase;
  text-decoration: none;
  border-radius: 2px;
  transition: all 0.3s;
}
.ghost-btn:hover {
  background: rgba(255,0,0,0.12);
  border-color: rgba(255,60,60,0.6);
  box-shadow: 0 0 30px rgba(255,0,0,0.1);
}
.ghost-btn.muted {
  border-color: rgba(255,255,255,0.15);
  color: rgba(255,255,255,0.4);
  background: transparent;
}
.ghost-btn.muted:hover {
  border-color: rgba(255,255,255,0.3);
  color: rgba(255,255,255,0.6);
  box-shadow: none;
}

/* Red line divider */
.red-line {
  height: 2px;
  background: linear-gradient(90deg, transparent, rgba(255,0,0,0.2), transparent);
  max-width: 960px;
  margin: 0 auto;
}

/* Section label */
.section-label {
  font-size: 11px;
  letter-spacing: 5px;
  text-transform: uppercase;
  color: rgba(255,0,0,0.45);
  margin-bottom: 48px;
  font-weight: 600;
}

/* === SYSTEMS OPERATIONAL === */
.systems {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 80px 40px;
  max-width: 960px;
  margin: 0 auto;
}
.system-row {
  display: flex;
  align-items: stretch;
  margin-bottom: 2px;
  height: 56px;
}
.system-label {
  width: 200px;
  flex-shrink: 0;
  padding: 0 16px;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 1.5px;
  text-transform: uppercase;
  display: flex;
  align-items: center;
  color: #fff;
}
.system-label.red { background: #cc2222; }
.system-label.cyan { background: #1a8a8a; }
.system-label.green { background: #5a7a22; }
.system-label.amber { background: #8a6a1a; }
.system-label.blue { background: #2244aa; }
.system-readout {
  flex: 1;
  background: #0a0a0a;
  position: relative;
  overflow: hidden;
}
.system-readout::before {
  content: '';
  position: absolute;
  inset: 0;
  background:
    repeating-linear-gradient(90deg, rgba(255,50,50,0.06) 0px, rgba(255,50,50,0.06) 1px, transparent 1px, transparent 32px),
    repeating-linear-gradient(0deg, rgba(255,50,50,0.06) 0px, rgba(255,50,50,0.06) 1px, transparent 1px, transparent 28px);
  pointer-events: none;
}
.system-readout.cyan-grid::before {
  background:
    repeating-linear-gradient(90deg, rgba(0,200,200,0.06) 0px, rgba(0,200,200,0.06) 1px, transparent 1px, transparent 32px),
    repeating-linear-gradient(0deg, rgba(0,200,200,0.06) 0px, rgba(0,200,200,0.06) 1px, transparent 1px, transparent 28px);
}
.waveform-svg {
  position: absolute;
  top: 0; left: 0;
  width: 200%;
  height: 100%;
  animation: waveScroll 6s linear infinite;
}
@keyframes waveScroll {
  0% { transform: translateX(0); }
  100% { transform: translateX(-50%); }
}
.system-value {
  position: absolute;
  right: 16px;
  top: 50%;
  transform: translateY(-50%);
  font-family: 'Courier New', monospace;
  font-size: 11px;
  color: rgba(255,255,255,0.4);
  letter-spacing: 1px;
}

/* === BLUE DIAGNOSTIC SCREEN === */
.diagnostic {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 80px 40px;
}
.diag-wrapper { max-width: 800px; width: 100%; }
.diag-screen {
  background: linear-gradient(135deg, #0a1a3a 0%, #0d1f42 50%, #081530 100%);
  border: 2px solid #1a3a6a;
  padding: 40px;
  font-family: 'Courier New', monospace;
  position: relative;
  overflow: hidden;
  box-shadow: 0 0 60px rgba(40,80,200,0.1), inset 0 0 80px rgba(40,80,200,0.05);
}
.diag-screen::before {
  content: '';
  position: absolute;
  inset: 0;
  background: repeating-linear-gradient(0deg, transparent, transparent 2px, rgba(60,120,255,0.02) 2px, rgba(60,120,255,0.02) 4px);
  pointer-events: none;
}
.diag-screen::after {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(ellipse at center, rgba(60,120,255,0.06) 0%, transparent 70%);
  pointer-events: none;
}
.diag-title {
  color: #5588cc;
  font-size: 11px;
  letter-spacing: 3px;
  margin-bottom: 28px;
  text-transform: uppercase;
}
.diag-line {
  color: rgba(150,200,255,0.7);
  font-size: 13px;
  line-height: 2.2;
  display: flex;
}
.diag-label {
  color: rgba(150,200,255,0.35);
  width: 220px;
  flex-shrink: 0;
}
.diag-val { color: rgba(200,230,255,0.85); }
.diag-cursor {
  display: inline-block;
  width: 8px; height: 14px;
  background: rgba(150,200,255,0.5);
  animation: blink 1s step-end infinite;
  margin-left: 4px;
  vertical-align: middle;
}
@keyframes blink { 50% { opacity: 0; } }

/* === LOGIC MEMORY CENTER === */
.memory-center {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 80px 40px;
}
.panel-plate {
  max-width: 860px;
  width: 100%;
  background:
    repeating-linear-gradient(90deg, rgba(0,0,0,0.02) 0px, transparent 1px, transparent 3px),
    linear-gradient(180deg, #d0d0d0 0%, #c0c0c0 30%, #b8b8b8 70%, #c4c4c4 100%);
  border-radius: 3px;
  padding: 40px;
  position: relative;
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.6), inset 0 -1px 0 rgba(0,0,0,0.15), 0 8px 40px rgba(0,0,0,0.6);
}
.panel-header {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 24px;
}
.panel-header-text {
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 4px;
  text-transform: uppercase;
  color: #333;
}
.panel-hal-badge {
  background: #0a1a3a;
  padding: 2px 10px;
  font-family: 'Courier New', monospace;
  font-size: 9px;
  color: rgba(100,180,255,0.7);
  letter-spacing: 1px;
  border: 1px solid rgba(100,180,255,0.2);
}
.panel-grid {
  display: grid;
  grid-template-columns: 1fr 3px 1fr;
  gap: 0;
}
.panel-cell {
  border: 2px solid #cc2222;
  padding: 24px;
  min-height: 120px;
}
.panel-cell.filled { background: #cc2222; color: #fff; }
.panel-cell.empty { background: transparent; }
.panel-cell h3 {
  font-size: 15px;
  font-weight: 700;
  letter-spacing: 3px;
  text-transform: uppercase;
  margin-bottom: 10px;
}
.panel-cell.filled h3 { color: #fff; }
.panel-cell.empty h3 { color: #333; }
.panel-cell p { font-size: 11px; line-height: 1.7; letter-spacing: 0.3px; }
.panel-cell.filled p { color: rgba(255,255,255,0.85); }
.panel-cell.empty p { color: #666; }
.panel-divider { width: 3px; }

/* Memory terminal bars */
.bars-unit {
  background: #cc2222;
  padding: 20px 24px 28px;
  margin-top: 3px;
}
.bars-labels {
  display: flex;
  justify-content: space-between;
  margin-bottom: 14px;
}
.bars-labels span {
  font-size: 9px;
  letter-spacing: 3px;
  text-transform: uppercase;
  color: rgba(255,255,255,0.65);
  font-weight: 600;
}
.bars-row {
  display: flex;
  gap: 5px;
  justify-content: center;
}
.bar-mod {
  width: 42px; height: 64px;
  background: linear-gradient(180deg, #f8f8f8 0%, #eee 100%);
  border-radius: 1px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-end;
  padding-bottom: 6px;
  box-shadow: 3px 0 6px rgba(0,0,0,0.25), inset 0 1px 0 rgba(255,255,255,0.8);
}
.bar-mod .bnum { font-size: 9px; color: #888; font-weight: 600; }
.bar-mod .blabel { font-size: 7px; color: #aaa; letter-spacing: 0.5px; margin-bottom: 2px; }
.bar-gap { width: 24px; }

/* === INSTALL === */
.install {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 80px 40px;
  max-width: 800px;
  margin: 0 auto;
}
.install-step {
  display: flex;
  gap: 24px;
  margin-bottom: 32px;
  align-items: flex-start;
}
.step-num {
  font-family: 'Courier New', monospace;
  font-size: 13px;
  color: rgba(255,0,0,0.4);
  flex-shrink: 0;
  width: 28px;
  padding-top: 2px;
}
.step-text {
  color: rgba(255,255,255,0.5);
  font-size: 14px;
  margin-bottom: 10px;
  letter-spacing: 0.5px;
}
.step-code {
  background: linear-gradient(135deg, #0a1a3a 0%, #0d1f42 100%);
  border: 1px solid rgba(26,58,106,0.4);
  padding: 14px 18px;
  font-family: 'Courier New', monospace;
  font-size: 12px;
  color: rgba(150,200,255,0.8);
  line-height: 1.8;
  overflow-x: auto;
}
.install-buttons {
  margin-top: 48px;
  text-align: center;
  display: flex;
  gap: 16px;
  justify-content: center;
}

/* === FOOTER === */
.footer {
  padding: 60px 40px;
  text-align: center;
  border-top: 1px solid rgba(255,255,255,0.03);
}
.footer-text {
  font-size: 10px;
  letter-spacing: 4px;
  text-transform: uppercase;
  color: rgba(255,255,255,0.12);
}
.footer-disclaimer {
  max-width: 600px;
  margin: 16px auto 0;
  font-size: 10px;
  color: rgba(255,255,255,0.08);
  line-height: 1.8;
}

/* === RESPONSIVE === */
@media (max-width: 960px) {
  .hero-title { font-size: 32px; letter-spacing: 10px; }
  .hal-eye-housing { width: 150px; height: 280px; }
  .hal-eye { width: 110px; height: 110px; }
  .system-label { width: 160px; font-size: 10px; }
  .panel-plate { padding: 24px; }
}
@media (max-width: 640px) {
  .hero-title { font-size: 24px; letter-spacing: 6px; }
  .hero-tagline { font-size: 14px; }
  .hal-eye-housing { width: 120px; height: 220px; }
  .hal-eye { width: 90px; height: 90px; }
  .hal-eye-inner { width: 20px; height: 20px; }
  .system-row { flex-direction: column; height: auto; }
  .system-label { width: 100%; height: 32px; }
  .system-readout { height: 48px; }
  .panel-grid { grid-template-columns: 1fr; }
  .panel-divider { display: none; }
  .diag-line { flex-direction: column; }
  .diag-label { width: auto; }
  .bars-row { flex-wrap: wrap; }
  .install-buttons { flex-direction: column; align-items: center; }
}
```

The CSS above is the complete stylesheet. Write it into the `<style>` tag. Key difference from mockup: the eye housing is now `180px` wide by `340px` tall — portrait-oriented to match the real film prop.

- [ ] **Step 2: Open in browser, verify hero section renders correctly**

```bash
open docs/index.html
```

Expected: Full-viewport hero with tall narrow HAL eye housing, red eye with lens rings, title, tagline, and install button. Black background with subtle red radial gradient.

- [ ] **Step 3: Commit**

```bash
git add docs/index.html
git commit -m "feat: landing page CSS — hero, eye housing, base styles"
```

---

### Task 4: Add Remaining Page Sections (HTML)

Add the Systems Operational, Blue Diagnostic Screen, Logic Memory Center, Installation Sequence, and Footer sections.

**Files:**
- Modify: `docs/index.html` — add HTML after the hero's closing `</section>` and `<div class="red-line"></div>`

- [ ] **Step 1: Add Systems Operational section**

Insert after the first `<div class="red-line"></div>`:

```html
<!-- SYSTEMS OPERATIONAL -->
<section class="systems">
  <div class="section-label">Systems Operational</div>

  <div class="system-row">
    <div class="system-label red">Voice<br>Synthesis</div>
    <div class="system-readout">
      <svg class="waveform-svg" viewBox="0 0 800 56" preserveAspectRatio="none">
        <polyline fill="none" stroke="rgba(255,255,255,0.6)" stroke-width="1.5"
          points="0,28 10,20 20,28 30,12 40,28 50,22 60,28 70,8 80,28 90,18 100,28 110,24 120,28 130,14 140,28 150,20 160,28 170,32 180,28 190,10 200,28 210,22 220,28 230,16 240,28 250,26 260,28 270,12 280,28 290,20 300,28 310,8 320,28 330,22 340,28 350,18 360,28 370,14 380,28 390,24 400,28 410,20 420,28 430,12 440,28 450,22 460,28 470,8 480,28 490,18 500,28 510,24 520,28 530,14 540,28 550,20 560,28 570,32 580,28 590,10 600,28 610,22 620,28 630,16 640,28 650,26 660,28 670,12 680,28 690,20 700,28 710,8 720,28 730,22 740,28 750,18 760,28 770,14 780,28 790,24 800,28"/>
      </svg>
      <div class="system-value">~0.7s / sentence</div>
    </div>
  </div>

  <div class="system-row">
    <div class="system-label cyan">Neural<br>Engine</div>
    <div class="system-readout cyan-grid">
      <svg class="waveform-svg" style="animation-duration:8s;" viewBox="0 0 800 56" preserveAspectRatio="none">
        <polyline fill="none" stroke="rgba(255,255,255,0.45)" stroke-width="1.5"
          points="0,28 20,26 40,28 60,24 80,28 100,30 120,28 140,22 160,28 180,26 200,28 220,30 240,28 260,24 280,28 300,26 320,28 340,30 360,28 380,22 400,28 420,26 440,28 460,30 480,28 500,24 520,28 540,26 560,28 580,30 600,28 620,22 640,28 660,26 680,28 700,30 720,28 740,24 760,28 780,26 800,28"/>
      </svg>
      <div class="system-value">Piper ONNX</div>
    </div>
  </div>

  <div class="system-row">
    <div class="system-label red">Audio<br>Pipeline</div>
    <div class="system-readout">
      <svg class="waveform-svg" style="animation-duration:5s;" viewBox="0 0 800 56" preserveAspectRatio="none">
        <polyline fill="none" stroke="rgba(255,255,255,0.5)" stroke-width="1.5"
          points="0,28 15,18 30,28 45,22 60,28 75,14 90,28 105,24 120,28 135,16 150,28 165,20 180,28 195,26 210,28 225,12 240,28 255,22 270,28 285,18 300,28 315,24 330,28 345,14 360,28 375,20 390,28 405,26 420,28 435,16 450,28 465,22 480,28 495,12 510,28 525,24 540,28 555,18 570,28 585,20 600,28 615,26 630,28 645,14 660,28 675,22 690,28 705,16 720,28 735,24 750,28 765,20 780,28 795,18 800,28"/>
      </svg>
      <div class="system-value">22050 Hz WAV</div>
    </div>
  </div>

  <div class="system-row">
    <div class="system-label green">Systems<br>Integration</div>
    <div class="system-readout">
      <svg class="waveform-svg" style="animation-duration:10s;" viewBox="0 0 800 56" preserveAspectRatio="none">
        <polyline fill="none" stroke="rgba(255,255,255,0.35)" stroke-width="1.5"
          points="0,28 40,26 80,28 120,27 160,28 200,26 240,28 280,27 320,28 360,26 400,28 440,27 480,28 520,26 560,28 600,27 640,28 680,26 720,28 760,27 800,28"/>
      </svg>
      <div class="system-value">Claude Code</div>
    </div>
  </div>

  <div class="system-row">
    <div class="system-label amber">Persona<br>Module</div>
    <div class="system-readout">
      <svg class="waveform-svg" style="animation-duration:7s;" viewBox="0 0 800 56" preserveAspectRatio="none">
        <polyline fill="none" stroke="rgba(255,255,255,0.5)" stroke-width="1.5"
          points="0,28 12,22 24,28 36,16 48,28 60,24 72,28 84,10 96,28 108,20 120,28 132,26 144,28 156,14 168,28 180,22 192,28 204,18 216,28 228,24 240,28 252,12 264,28 276,20 288,28 300,26 312,28 324,16 336,28 348,22 360,28 372,10 384,28 396,24 408,28 420,18 432,28 444,20 456,28 468,14 480,28 492,26 504,28 516,22 528,28 540,12 552,28 564,24 576,28 588,16 600,28 612,20 624,28 636,26 648,28 660,14 672,28 684,22 696,28 708,18 720,28 732,24 744,28 756,10 768,28 780,20 792,28 800,28"/>
      </svg>
      <div class="system-value">HAL 9000</div>
    </div>
  </div>
</section>

<div class="red-line"></div>
```

- [ ] **Step 2: Add Blue Diagnostic Screen section**

```html
<!-- BLUE DIAGNOSTIC SCREEN -->
<section class="diagnostic">
  <div class="diag-wrapper">
    <div class="diag-screen">
      <div class="diag-title">PROG: OPENHAL/9000/SYS/STATUS</div>
      <div class="diag-line"><span class="diag-label">TTS ENGINE</span><span class="diag-val">PIPER (NATIVE ONNX)</span></div>
      <div class="diag-line"><span class="diag-label">VOICE MODEL</span><span class="diag-val">HAL-9000-PIPER-TTS &mdash; 63MB</span></div>
      <div class="diag-line"><span class="diag-label">ARCHITECTURE</span><span class="diag-val">APPLE SILICON (ARM64)</span></div>
      <div class="diag-line"><span class="diag-label">SAMPLE RATE</span><span class="diag-val">22050 HZ / 16-BIT / MONO</span></div>
      <div class="diag-line"><span class="diag-label">LENGTH SCALE</span><span class="diag-val">0.92</span></div>
      <div class="diag-line"><span class="diag-label">DEPENDENCIES</span><span class="diag-val">PYTHON 3 + CLAUDE CODE</span></div>
      <div class="diag-line"><span class="diag-label">DOCKER</span><span class="diag-val">NOT REQUIRED</span></div>
      <div class="diag-line"><span class="diag-label">FFMPEG</span><span class="diag-val">NOT REQUIRED</span></div>
      <div class="diag-line"><span class="diag-label">STATUS</span><span class="diag-val">ALL SYSTEMS OPERATIONAL<span class="diag-cursor"></span></span></div>
    </div>
  </div>
</section>

<div class="red-line"></div>
```

- [ ] **Step 3: Add Logic Memory Center and Memory Terminal Bars**

```html
<!-- LOGIC MEMORY CENTER -->
<section class="memory-center">
  <div>
    <div class="panel-plate">
      <div class="screw tl"></div>
      <div class="screw tr"></div>
      <div class="screw bl"></div>
      <div class="screw br"></div>
      <div class="panel-header">
        <span class="panel-header-text">Maximum Restricted Entry</span>
        <span class="panel-hal-badge">HAL 9000</span>
        <span class="panel-header-text" style="margin-left:auto;">Logic Memory Center</span>
      </div>
      <div class="panel-grid">
        <div class="panel-cell filled">
          <h3>Native TTS</h3>
          <p>Piper runs directly on Apple Silicon. No containers. No servers. No network overhead. ~0.7 seconds per sentence.</p>
        </div>
        <div class="panel-divider"></div>
        <div class="panel-cell empty">
          <h3>Zero Config</h3>
          <p>First session bootstraps everything automatically. Downloads model, creates venv, verifies install. HAL sings you a song.</p>
        </div>
        <div class="panel-cell empty">
          <h3>In Character</h3>
          <p>HAL doesn't read your code aloud. He editorializes. Summarizes. Calm, precise, and politely unsettling.</p>
        </div>
        <div class="panel-divider"></div>
        <div class="panel-cell filled">
          <h3>Voice Control</h3>
          <p>Toggle voice on and off. Adjust speech rate. Full /hal command suite for mode, status, setup.</p>
        </div>
      </div>
    </div>
    <div class="bars-unit">
      <div class="bars-labels">
        <span>IV-3 Logic Terminal</span>
        <span>Memory Terminal</span>
      </div>
      <div class="bars-row">
        <div class="bar-mod"><span class="blabel">LT/1</span><span class="bnum">1</span></div>
        <div class="bar-mod"><span class="blabel">LT/1</span><span class="bnum">2</span></div>
        <div class="bar-mod"><span class="blabel">LT/2</span><span class="bnum">3</span></div>
        <div class="bar-mod"><span class="blabel">LT/2</span><span class="bnum">4</span></div>
        <div class="bar-mod"><span class="blabel">LT/3</span><span class="bnum">5</span></div>
        <div class="bar-mod"><span class="blabel">LT/3</span><span class="bnum">6</span></div>
        <div class="bar-gap"></div>
        <div class="bar-mod"><span class="blabel">MT</span><span class="bnum">1</span></div>
        <div class="bar-mod"><span class="blabel">MT</span><span class="bnum">2</span></div>
        <div class="bar-mod"><span class="blabel">MT</span><span class="bnum">3</span></div>
        <div class="bar-mod"><span class="blabel">MT</span><span class="bnum">4</span></div>
        <div class="bar-mod"><span class="blabel">MT</span><span class="bnum">5</span></div>
        <div class="bar-mod"><span class="blabel">MT</span><span class="bnum">6</span></div>
      </div>
    </div>
  </div>
</section>

<div class="red-line"></div>
```

- [ ] **Step 4: Add Installation Sequence and Footer**

```html
<!-- INSTALLATION SEQUENCE -->
<section class="install" id="install">
  <div class="section-label">Installation Sequence</div>
  <div>
    <div class="install-step">
      <div class="step-num">01</div>
      <div>
        <div class="step-text">Add the marketplace to your Claude Code settings:</div>
        <div class="step-code"><pre>{
  "extraKnownMarketplaces": {
    "leal-labs": {
      "source": { "source": "github", "repo": "davesleal/openhal-9000" }
    }
  }
}</pre></div>
      </div>
    </div>
    <div class="install-step">
      <div class="step-num">02</div>
      <div>
        <div class="step-text">In Claude Code, install the plugin:</div>
        <div class="step-code"><pre>/plugins → install openhal-9000</pre></div>
      </div>
    </div>
    <div class="install-step">
      <div class="step-num">03</div>
      <div>
        <div class="step-text">Start a new session. HAL bootstraps automatically — downloads the voice model, sets up Piper, and introduces himself.</div>
      </div>
    </div>
  </div>
  <div class="install-buttons">
    <a href="https://github.com/davesleal/openhal-9000" class="ghost-btn">GitHub</a>
    <a href="https://github.com/davesleal/openhal-9000#usage" class="ghost-btn muted">Documentation</a>
  </div>
</section>

<!-- FOOTER -->
<footer class="footer">
  <div class="footer-text">Created by Dave Leal — Leal Labs — MIT License</div>
  <p class="footer-disclaimer">Not affiliated with MGM, Warner Bros., Amazon, or the Arthur C. Clarke estate. An independent open-source experiment for educational and entertainment purposes.</p>
</footer>
```

- [ ] **Step 5: Open in browser, verify all sections render**

```bash
open docs/index.html
```

Expected: Six sections, each roughly 100vh. Scroll through: hero → systems → diagnostic → memory center → install → footer. Animations running on waveforms. Blinking cursor on diagnostic screen.

- [ ] **Step 6: Commit**

```bash
git add docs/index.html
git commit -m "feat: landing page sections — systems, diagnostic, features, install"
```

---

### Task 5: Add Voice Playback JavaScript

Add the inline `<script>` that handles Web Audio API playback of the HAL greeting and smooth scroll for the install button.

**Files:**
- Modify: `docs/index.html` — add `<script>` before `</body>`

- [ ] **Step 1: Add the script block before `</body>`**

```html
<script>
  // Smooth scroll for install button
  document.querySelectorAll('a[href="#install"]').forEach(function(a) {
    a.addEventListener('click', function(e) {
      e.preventDefault();
      document.getElementById('install').scrollIntoView({ behavior: 'smooth' });
    });
  });

  // HAL voice greeting via Web Audio API
  (function() {
    var played = false;
    var playBtn = document.getElementById('hal-play');
    var housing = document.querySelector('.hal-eye-housing');

    function playGreeting() {
      if (played) return;
      played = true;
      playBtn.textContent = '● Playing...';
      playBtn.style.color = 'rgba(255,100,100,0.7)';

      fetch('hal-greeting.wav')
        .then(function(r) { return r.arrayBuffer(); })
        .then(function(buf) {
          var ctx = new (window.AudioContext || window.webkitAudioContext)();
          return ctx.decodeAudioData(buf).then(function(decoded) {
            var source = ctx.createBufferSource();
            source.buffer = decoded;
            source.connect(ctx.destination);
            source.start(0);
            source.onended = function() {
              playBtn.textContent = '✓ HAL has spoken';
              playBtn.style.color = 'rgba(255,100,100,0.3)';
            };
          });
        })
        .catch(function() {
          playBtn.textContent = '▶ Click to hear HAL speak';
          playBtn.style.color = 'rgba(255,100,100,0.35)';
          played = false;
        });
    }

    playBtn.addEventListener('click', playGreeting);
    housing.addEventListener('click', playGreeting);
  })();
</script>
```

- [ ] **Step 2: Test in browser**

```bash
open docs/index.html
```

Test:
1. Click the play label — should play the HAL greeting WAV
2. Click "INSTALL" button — should smooth-scroll to install section
3. Click the eye housing — should also play the greeting
4. Second click should not replay (played flag)

- [ ] **Step 3: Commit**

```bash
git add docs/index.html
git commit -m "feat: voice playback (Web Audio API) and smooth scroll"
```

---

### Task 6: Enable GitHub Pages and Final Polish

Configure GitHub Pages to serve from `/docs` and do a final visual pass.

**Files:**
- Modify: `docs/index.html` — any final CSS tweaks found during visual review

- [ ] **Step 1: Add `.gitignore` entry for superpowers brainstorm files**

Add to the repo's `.gitignore`:

```
.superpowers/
```

- [ ] **Step 2: Visual review in browser**

```bash
open docs/index.html
```

Check:
- Hero: HAL eye housing is portrait-oriented (taller than wide), lighter than pure black background
- All 5 system readout rows visible with animated waveforms
- Blue diagnostic screen has CRT glow and blinking cursor
- Logic Memory Center has brushed metal texture with screws
- Memory terminal bars visible beneath
- Install steps are clear and code blocks readable
- Footer text visible but very subtle
- Responsive: resize browser to tablet and mobile widths

- [ ] **Step 3: Enable GitHub Pages via CLI**

```bash
gh api repos/davesleal/openhal-9000/pages -X POST -f source='{"branch":"main","path":"/docs"}' 2>/dev/null || \
gh api repos/davesleal/openhal-9000/pages -X PUT -f source='{"branch":"main","path":"/docs"}'
```

If the API format requires different fields:

```bash
gh api repos/davesleal/openhal-9000/pages -X POST \
  --field build_type=legacy \
  --field source='{"branch":"main","path":"/docs"}'
```

- [ ] **Step 4: Push and verify deployment**

```bash
git push origin main
```

Wait 1-2 minutes, then verify:

```bash
gh api repos/davesleal/openhal-9000/pages --jq '.html_url'
# Expected: https://davesleal.github.io/openhal-9000/
```

- [ ] **Step 5: Commit any final polish**

```bash
git add -A
git commit -m "chore: enable GitHub Pages, add .gitignore for brainstorm files"
git push origin main
```

---

## Summary

| Task | What | Files |
|------|------|-------|
| 1 | Generate HAL greeting WAV | `docs/hal-greeting.wav` |
| 2 | HTML structure + hero | `docs/index.html` |
| 3 | Complete CSS stylesheet | `docs/index.html` (style block) |
| 4 | All remaining HTML sections | `docs/index.html` (body) |
| 5 | Voice playback JS + smooth scroll | `docs/index.html` (script block) |
| 6 | GitHub Pages setup + polish | `.gitignore`, push |
