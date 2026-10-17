---
name: Hakim Kone, ML Engineer
description: Bilingual portfolio that reads like an engineer's field notebook, annotated by one detection-green signal.
colors:
  paper: "#f5f7f2"
  ink: "#18212b"
  muted: "#586371"
  line: "#d8ded3"
  plate: "#ffffff"
  detection-green: "#5da327"
  annotation-ink: "#2e6a12"
  on-accent: "#ffffff"
  label-ink: "#0e1a06"
  paper-dark: "#121714"
  ink-dark: "#e4e9e1"
  muted-dark: "#9ca69d"
  line-dark: "#2a332d"
  plate-dark: "#f2f4ef"
  detection-green-dark: "#7cc94a"
  annotation-ink-dark: "#9bdb6e"
  on-accent-dark: "#121714"
typography:
  display:
    fontFamily: "Source Sans 3, system-ui, sans-serif"
    fontSize: "clamp(2.5rem, 6.5vw, 4.4rem)"
    fontWeight: 700
    lineHeight: 1
    letterSpacing: "-0.025em"
  headline:
    fontFamily: "Source Sans 3, system-ui, sans-serif"
    fontSize: "clamp(2rem, 5vw, 3rem)"
    fontWeight: 700
    lineHeight: 1.15
    letterSpacing: "-0.02em"
  lede:
    fontFamily: "Source Sans 3, system-ui, sans-serif"
    fontSize: "clamp(1.3rem, 2.4vw, 1.65rem)"
    fontWeight: 400
    lineHeight: 1.35
  title:
    fontFamily: "Source Sans 3, system-ui, sans-serif"
    fontSize: "1.3rem"
    fontWeight: 600
    lineHeight: 1.15
  body:
    fontFamily: "Source Sans 3, system-ui, sans-serif"
    fontSize: "1.125rem"
    fontWeight: 400
    lineHeight: 1.6
  label:
    fontFamily: "Source Sans 3, system-ui, sans-serif"
    fontSize: "0.95rem"
    fontWeight: 400
    lineHeight: 1.6
rounded:
  hairline: "2px"
  code: "3px"
  plate: "4px"
  button: "6px"
spacing:
  gutter: "clamp(1.25rem, 5vw, 3rem)"
  label-col: "11rem"
  container: "68rem"
  measure: "46rem"
  block: "3rem"
components:
  button-primary:
    backgroundColor: "{colors.annotation-ink}"
    textColor: "{colors.on-accent}"
    rounded: "{rounded.button}"
    padding: "0.6rem 1.15rem"
  button-quiet:
    backgroundColor: "transparent"
    textColor: "{colors.annotation-ink}"
    rounded: "{rounded.button}"
    padding: "0.6rem 1.15rem"
  project-thumb:
    backgroundColor: "{colors.plate}"
    rounded: "{rounded.plate}"
    padding: "0.4rem"
  detector-label:
    backgroundColor: "{colors.detection-green}"
    textColor: "{colors.label-ink}"
    padding: "0.05rem 0.45rem"
---

# Design System: Hakim Kone, ML Engineer

## Overview

**Creative North Star: "The Field Notebook"**

The site reads like an engineer's working record: off-white paper, dark ink, one typeface, and a left-hand margin where each section's name sits beside its evidence. Nothing is staged. The hierarchy comes from weight and size inside a single family, and sections are separated by hairline rules rather than cards or panels. A reader who wants depth gets long, calm prose; a reader who scans gets labels, dates, and stacks in muted ink.

One green carries every signal. It underlines links, fills the main action, rings keyboard focus, and draws the only ornament: a detection bounding box that locks onto the portrait with a confidence label (`ml_engineer 0.98`), a nod to the computer-vision work. That box is the notebook's one annotation in the margin; everything else stays plain.

The system is flat, light by default, and follows the reader's OS into a dark mode with the same structure. There is no JavaScript and only one animation.

**Key Characteristics:**
- Paper and ink, green only as signal.
- One family (Source Sans 3) with hierarchy by weight and size.
- Label column on the left, content on the right; one column on narrow screens.
- Hairline rules instead of surfaces; no shadows.
- One signature: the detector bounding box on the portrait.

## Colors

A cool-ink, faintly green-tinted neutral field with a single detection green split into a graphic tone and a text-safe tone.

### Primary
- **Detection Green** (`detection-green`): graphics only. Used for the portrait bounding box and its label background, and for the focus ring. It is too light for body text on paper.
- **Annotation Ink** (`annotation-ink`): the text-safe green. Used for links, nav hover, the filled primary button, and the outline of the quiet button.

### Neutral
- **Notebook Paper** (`paper`): page background, a barely green off-white.
- **Slate Ink** (`ink`): body text, headings, the brand name, nav links, project titles.
- **Pencil Grey** (`muted`): secondary text such as role, dates, places, tech stacks, intros, footer, captions, and the language switch.
- **Ruled Line** (`line`): hairline section dividers, image borders, inline code background.
- **Plate White** (`plate`): backing behind thumbnails and media, so screenshots with transparent or light edges sit on a consistent plate.
- **On Accent** (`on-accent`) and **Label Ink** (`label-ink`): text on Annotation Ink buttons and on the Detection Green label respectively.

CSS variables in `assets/css/main.css` keep short names: `--accent` is Detection Green, `--accent-ink` is Annotation Ink; the other roles share their token names (`--paper`, `--ink`, `--muted`, `--line`, `--plate`, `--on-accent`, `--label-ink`).

### Dark mode

`prefers-color-scheme: dark` swaps every role to its `-dark` token. The structure is unchanged. Both greens get lighter, and Plate stays near-white so media keeps its light backing.

### Named Rules
**The One Signal Rule.** Green means "this is interactive or this is the annotation". Never use it for decoration, section tints, or headings.

**The Two Greens Rule.** Detection Green is for strokes and fills behind dark text; Annotation Ink is for green text and filled buttons. Never set text in Detection Green on paper.

## Typography

**Display Font:** Source Sans 3 (with system-ui, sans-serif), self-hosted variable font (200 to 900), shared with the CV.
**Body Font:** same family.

**Character:** A humanist sans that reads as plain and modern without being sterile. One family keeps the notebook honest: emphasis comes from weight, never from a second voice.

### Hierarchy
- **Display** (700, clamp 2.5 to 4.4rem, line-height 1, -0.025em): the name in the home hero only, max 12ch.
- **Headline** (700, clamp 2 to 3rem, -0.02em): case study titles.
- **Lede** (400, clamp 1.3 to 1.65rem, line-height 1.35, max 34ch, 40ch on case studies): the headline sentence under a title.
- **Title** (600, 1.3rem; 1.35rem for case-study section heads; 1.15 to 1.2rem for entries): section names in the label column, prose `h2`, experience and project names.
- **Body** (400, 1.125rem, line-height 1.6): all running text; case study prose capped at 68ch.
- **Label** (400, 0.95rem, Pencil Grey): dates, places, tech stacks, captions, footer, back link.

### Named Rules
**The Weight-Not-Font Rule.** Hierarchy is built from 400, 600, and 700 in one family. Do not introduce a second typeface, italics for emphasis, or uppercase tracking.

## Layout

A centered 68rem frame with a fluid gutter (clamp 1.25 to 3rem). Home sections are two-column grids: an 11rem label column holding the section name, and a content column of at most 46rem, separated by a 3rem gap and a hairline top border with 3rem vertical padding. Entries inside repeat the pattern: experience and skills use a 9.5rem date or category column, projects use a 13rem thumbnail column.

The hero is a two-column grid (text, portrait at 320px) with generous fluid vertical padding (up to 6rem). Case studies are a single 46rem column with prose capped at 68ch.

Vertical rhythm uses owl spacing (`* + *`): 1rem between prose blocks, 2.25 to 2.5rem between list entries, 2.25rem before prose section heads.

At 52rem and below, every grid collapses to one column, the portrait shrinks to 200px and moves below the text, and project thumbnails cap at 22rem.

## Elevation & Depth

Flat. There are no shadows anywhere. Depth comes from tone only: media sit on a Plate White backing with a one-pixel Ruled Line border, which lifts them a step off the paper. Sections are divided by hairlines, not containers.

### Named Rules
**The Ruled Page Rule.** Separate content with a 1px Ruled Line or with space, never with shadows, cards, or tinted panels.

## Shapes

Corners are nearly square and get only slightly rounder as the element gets more interactive: 2px on the portrait and focus ring, 3px on inline code, 4px on media plates, 6px on buttons. Borders are 1px hairlines for structure and 2px strokes for the green (button outline, bounding box). The bounding box itself is a sharp-cornered rectangle with a flush label tab, like an object-detector overlay.

## Components

Restrained and exact: small radii, thin lines, no shadows; weight and the single green carry emphasis.

### Buttons
- **Shape:** gently squared (6px), 2px border in Annotation Ink.
- **Primary:** Annotation Ink fill, On Accent text, weight 600, padding 0.6rem by 1.15rem. Used for the one main action per view (email, code on GitHub, go home).
- **Quiet:** same shape and border, transparent fill, Annotation Ink text. Used for the secondary action (download CV).
- **Hover:** brightness lifts by 10%; no movement, no shadow.
- **Focus:** shared 3px Detection Green outline, 3px offset.

### Links
- Annotation Ink, 1px underline offset 0.2em; underline thickens to 2px on hover. Footer and nav links use Pencil Grey or Slate Ink instead and turn Annotation Ink on hover (nav only).

### Project thumbnails and media
- **Corner Style:** 4px.
- **Background:** Plate White with 0.4rem inner padding on thumbnails; images use `object-fit: contain` at a 14:9 ratio.
- **Border:** 1px Ruled Line.
- **Case-study media:** full width, capped at 32rem tall, with a Pencil Grey caption below.

### Navigation
- Brand name at 700 and 1.2rem in Slate Ink on the left; nav links on the right at body size in Slate Ink, no underline, Annotation Ink on hover. The language switch sits last in Pencil Grey. Header wraps naturally on narrow screens.

### Detector Box (signature)
A 2px Detection Green rectangle 10px outside the portrait, with a label tab above its top-left corner (Detection Green fill, Label Ink text, 0.8rem, weight 600) reading `ml_engineer 0.98`. On load it contracts from 34px out to 10px and fades in over 0.7s (`cubic-bezier(0.2, 0.8, 0.2, 1)`, 0.3s delay), only when the reader allows motion. It is decorative and hidden from assistive technology.

## Do's and Don'ts

### Do:
- **Do** keep green to links, the primary action, focus rings, and the detector box.
- **Do** put new home sections in the label-column grid with a hairline top border.
- **Do** use Pencil Grey at 0.95rem for metadata (dates, places, stacks, captions).
- **Do** back every screenshot or diagram with the Plate White plate and Ruled Line border.
- **Do** gate any motion behind `prefers-reduced-motion: no-preference`, and keep the detector lock as the only one.
- **Do** define every new color for both light and dark modes.

### Don't:
- **Don't** add shadows, cards, gradients, or tinted section backgrounds.
- **Don't** add a second typeface or set text in Detection Green on paper.
- **Don't** add JavaScript-driven effects; the site ships none.
- **Don't** repeat the bounding-box motif elsewhere; it is the single annotation.
- **Don't** round corners past 6px.
