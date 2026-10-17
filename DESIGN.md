---
name: Hakim Kone, ML Engineer
description: Bilingual portfolio that reads like an engineer's field notebook, annotated by one detection-green signal.
colors:
  paper: "#f7f7f5"
  ink: "#111214"
  muted: "#5c5f66"
  line: "#e0e0dc"
  plate: "#ffffff"
  detection-green: "#5da327"
  annotation-ink: "#2e6a12"
  on-accent: "#ffffff"
  label-ink: "#0e1a06"
  paper-dark: "#0f1011"
  ink-dark: "#ededeb"
  muted-dark: "#9a9ca1"
  line-dark: "#27292c"
  plate-dark: "#f2f2f0"
  detection-green-dark: "#7cc94a"
  annotation-ink-dark: "#9bdb6e"
  on-accent-dark: "#0f1011"
typography:
  display:
    fontFamily: "Geist, system-ui, sans-serif"
    fontSize: "clamp(2.75rem, 5.5vw, 4.25rem)"
    fontWeight: 700
    lineHeight: 1
    letterSpacing: "-0.04em"
  headline:
    fontFamily: "Geist, system-ui, sans-serif"
    fontSize: "clamp(2rem, 5vw, 3rem)"
    fontWeight: 700
    lineHeight: 1.15
    letterSpacing: "-0.02em"
  lede:
    fontFamily: "Geist, system-ui, sans-serif"
    fontSize: "clamp(1.3rem, 2.4vw, 1.65rem)"
    fontWeight: 400
    lineHeight: 1.35
  title:
    fontFamily: "Geist, system-ui, sans-serif"
    fontSize: "clamp(1.75rem, 3.2vw, 2.4rem)"
    fontWeight: 700
    lineHeight: 1.05
    letterSpacing: "-0.025em"
  body:
    fontFamily: "Geist, system-ui, sans-serif"
    fontSize: "1.0625rem"
    fontWeight: 400
    lineHeight: 1.6
  label:
    fontFamily: "Geist, system-ui, sans-serif"
    fontSize: "0.9rem"
    fontWeight: 400
    lineHeight: 1.6
  data:
    fontFamily: "Geist Mono, ui-monospace, monospace"
    fontSize: "0.9rem"
    fontWeight: 400
    lineHeight: 1.6
rounded:
  hairline: "2px"
  code: "3px"
  plate: "4px"
  button: "6px"
spacing:
  gutter: "clamp(1.25rem, 5vw, 3rem)"
  section: "clamp(3rem, 6vw, 4.5rem)"
  container: "68rem"
  measure: "46rem"
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
  bridge-out:
    textColor: "{colors.ink}"
    rounded: "{rounded.hairline}"
    padding: "0.3rem 0.75rem"
  project-cell:
    backgroundColor: "{colors.paper}"
    padding: "1.5rem"
---

# Design System: Hakim Kone, ML Engineer

## Overview

**Creative North Star: "The Field Notebook"**

The site reads like an engineer's working record: neutral off-white paper, near-black ink, one text face and its mono twin for data. The opening is calm; after it, each section starts with a large bold title under a 1px ink rule. Nothing is staged. A reader who wants depth gets long, calm prose; a reader who scans gets big titles, a diagram, a chart, and labels in muted ink.

Next to the name and headline, a small schematic states the positioning: the portrait on top, a thin stem that splits into infrastructure and modeling, and one green "Production" box at the bottom. Further down, the career and the learning path are drawn as month-scale charts where only the current role is green. These are diagrams of facts already in `profile.yaml`, not illustrations.

One green carries every signal. It underlines links, fills the main action, rings keyboard focus, marks what is live (the production node, the current role), and draws the detection bounding box that locks onto the portrait with a confidence label (`ml_engineer 0.98`), a nod to the computer-vision work.

The system is flat, light by default, and follows the reader's OS into a dark mode with the same structure; a header button overrides it. The only JavaScript is that switch, and there is only one animation.

**Key Characteristics:**
- Paper and ink, green only as signal.
- One text family (Geist) with hierarchy by weight and size; the name tops out at 4.25rem. Geist Mono sets data only.
- One section pattern after the hero: a large title over a 1px ink rule; one column on narrow screens.
- Diagrams of real facts: the bridge schematic and the career chart.
- Hairlines instead of surfaces; no shadows.
- One ornament: the detector bounding box on the portrait.

## Colors

A neutral, untinted field (no green cast in the greys) with a single detection green split into a graphic tone and a text-safe tone.

### Primary
- **Detection Green** (`detection-green`): graphics only. Used for the portrait bounding box and its label background, the focus ring, and live-status graphics: the production box's border and dot, and the current role's bar in the career chart. It is too light for body text on paper.
- **Annotation Ink** (`annotation-ink`): the text-safe green. Used for links, nav and project-title hover, the filled primary button, and the outline of the quiet button.

### Neutral
- **Notebook Paper** (`paper`): page background, a neutral warm-grey off-white.
- **Slate Ink** (`ink`): body text, headings, the brand name, nav links, project titles, section rules, bridge group titles, and past roles in the career chart.
- **Pencil Grey** (`muted`): secondary text such as role, dates, places, tech stacks, intros, footer, captions, bridge items, chart axis, and the language switch; also the bridge stem and split rule.
- **Ruled Line** (`line`): light dividers (bridge column divider, career rows, project grid lines, footer), image borders, inline code background.
- **Plate White** (`plate`): backing behind thumbnails and media, so screenshots with transparent or light edges sit on a consistent plate.
- **On Accent** (`on-accent`) and **Label Ink** (`label-ink`): text on Annotation Ink buttons and on the Detection Green label respectively.

CSS variables in `assets/css/main.css` keep short names: `--accent` is Detection Green, `--accent-ink` is Annotation Ink; the other roles share their token names (`--paper`, `--ink`, `--muted`, `--line`, `--plate`, `--on-accent`, `--label-ink`).

### Dark mode

`prefers-color-scheme: dark` swaps every role to its `-dark` token, unless the reader chose light. The header theme button sets `data-theme="light|dark"` on `<html>` and stores it in localStorage; an inline head script restores it before first paint. Without JavaScript the button stays hidden and the OS setting applies. The structure is unchanged. Both greens get lighter, and Plate stays near-white so media keeps its light backing.

### Named Rules
**The One Signal Rule.** Green means "this is interactive", "this is live", or "this is the annotation". Never use it for decoration, section tints, or headings.

**The Two Greens Rule.** Detection Green is for strokes and fills behind dark text; Annotation Ink is for green text and filled buttons. Never set text in Detection Green on paper.

## Typography

**Text Font:** Geist (with system-ui, sans-serif), self-hosted variable font (100 to 900), shared with the CV.
**Data Font:** Geist Mono, self-hosted variable font, web only.

**Character:** A precise, neutral grotesk: Swiss-clean, modern, never decorative. Emphasis comes from weight and size. Geist Mono is the measurement voice, used only where the text is data: role dates, cell years, chart axis years, inline code, and the detector label `ml_engineer 0.98`.

### Hierarchy
- **Display** (700, clamp 2.75 to 4.25rem, line-height 1, -0.04em): the name in the home hero only.
- **Headline** (700, clamp 2 to 3rem, -0.02em): case study titles.
- **Lede** (400, clamp 1.3 to 1.65rem, line-height 1.35, max 34ch): the headline sentence under a title.
- **Title** (700, clamp 1.75 to 2.4rem, line-height 1.05, -0.025em): home section titles. Entry titles use exactly two levels: 1.3rem 700 for primary entries (project names, degrees) and 1.15rem 600 for items (roles, certificates, skill groups). Case-study section heads are 1.05rem 600 in the left rail.
- **Body** (400, 1.0625rem, line-height 1.6): all running text; capped at 46rem on the home page and 68ch in case studies. Geist runs wide, so body stays under 1.125rem.
- **Label** (400, 0.9rem, Pencil Grey): dates, places, tech stacks, captions, footer, back link, chart company names. Role dates are in Geist Mono. The chart axis drops to 0.75rem Geist Mono with tabular numerals.

### Named Rules
**The Weight-Not-Font Rule.** Hierarchy is built from 400, 600, and 700 in Geist, and from size. Geist Mono is for data, never for headings, emphasis, or "technical" flavor. Do not introduce another typeface, italics for emphasis, or uppercase tracking.

## Layout

A centered 68rem frame with a fluid gutter (clamp 1.25 to 3rem). The page runs top to bottom in this order: hero (with the bridge diagram), About, then the large-title sections (Experience, Projects, Skills, Education · Certifications). There is no contact section: the hero's Email me button and the footer carry contact.

The hero is two columns centered vertically: text on the left (1fr), the bridge on the right (at most 23rem), with a 3 to 5rem gap and fluid vertical padding (clamp 3 to 5rem). Every section after it, About included, has a 1px ink top rule, fluid vertical padding (clamp 3 to 4.5rem), a large title, then content capped at 46rem. Exceptions are the About text, the two charts, the role list, the project grid, and the cells, which use the full width (the role list keeps its text at 46rem).

Inside sections: the role list uses a 9.5rem date column, both charts a 15rem label column, the projects a 2×2 grid, and Skills, Education and Certifications ruled cells.

Vertical rhythm uses owl spacing (`* + *`): 1rem between prose blocks, 0.35rem inside a cell.

Two breakpoints. At 52rem and below, the hero stacks (the bridge drops below the text, keeps its own layout, capped at 23rem, and is centered), the charts stack labels above bars, and the role list moves dates above titles. At 40rem and below, every remaining grid (projects, cells) goes to one column and both chart axes hide every other year. Four-column cells first drop to two at 64rem.

## Elevation & Depth

Flat. There are no shadows anywhere. Depth comes from tone and line only: media sit on a Plate White backing with a one-pixel Ruled Line border. Section divisions use 1px Slate Ink rules; the diagram uses Pencil Grey for its stem and split rule, and Ruled Line for minor dividers (bridge column divider, career rows, project grid, footer).

### Named Rules
**The Ruled Page Rule.** Separate content with 1px rules or with space, never with shadows, raised cards, or tinted panels. The project grid's lines come from a 1px gap over the line colour; the cells themselves are plain paper.

## Shapes

Corners are nearly square and get only slightly rounder as the element gets more interactive: 1px on chart bars, 2px on the portrait, production box, and focus ring, 3px on inline code, 4px on media plates, 6px on buttons. Borders are 1px hairlines for structure (including the production box) and 2px strokes for the button outline and the bounding box. The bounding box itself is a sharp-cornered rectangle with a flush label tab, like an object-detector overlay.

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

### Projects grid
- **Layout:** 2×2 grid separated by 1px Ruled Line (one column at 40rem and below); each cell is plain paper.
- **Cover:** runs edge to edge across the top of the cell: Plate White with 1rem inner padding, `object-fit: contain` at a 14:9 ratio, square corners, and a single 1px Ruled Line underneath (no outer border, the grid lines frame it).
- **Cell body (1.25rem top, 1.5rem sides and bottom):** title (1.3rem 700, Slate Ink, no underline, Annotation Ink and underlined on hover), then year · stack (Label), description, then an action bar pinned to the cell's bottom edge so bars line up across a row: a full-width strip on a 1px Ruled Line, split into two equal halves by a 1px line, each a 600 link with 0.75rem by 1.5rem padding and a drawn 14px arrow on the right ("Read the case study" in Annotation Ink with →, "Code on GitHub" in Slate Ink with ↗). Hover fills the half with Plate and Label Ink text.
- **Case study page:** back link, then the media across the full 68rem frame (capped at 36rem tall; images get 1rem of Plate White padding like the home thumbnails; Pencil Grey caption below), then the title (left) beside the lede (right), their last lines on one baseline, then a meta strip between two Ruled Lines: year in Geist Mono, stack joined by " · ", and the primary Code button pushed right. The write-up follows as a two-column grid: each section head sits in a 12rem left rail on a 1px Slate Ink rule, level with its first block of text, which starts on a 1px Ruled Line; text runs at 68ch. At 52rem and below, everything stacks into one column.

### Bridge (signature diagram)
A vertical schematic inside the hero, at most 23rem wide. The portrait (200px) with its detector box sits on top. A 1px Pencil Grey stem runs from the box's bottom edge down to a 1px Pencil Grey rule that splits into two columns: the second skill group ("MLOps and infrastructure") right-aligned on the left, the first ("Modeling") on the right after a 1px Ruled Line divider. Each column has a 600 title and its first four items in Pencil Grey at 0.95rem. A "Production" box closes the diagram: 1px Detection Green border, 2px corners, a filled green square, 600 weight. It keeps this layout on narrow screens.

### Career chart
One row per role: the company and start year on the left, a track with one grid column per month from the earliest start to the build date on the right. Past roles are Slate Ink bars (0.5rem tall); the current role is the only Detection Green bar. A final axis row marks each year. The chart is hidden from assistive technology because the role list below it carries the same facts.

### Role list
One native `<details>` per role (no JavaScript), spanning the section so the chevrons line up with the chart's right edge, separated by 1px Ruled Line rules. The summary row is always visible: dates (Label in Geist Mono, tabular numerals, one line: `01/2021 – 06/2025`, or `since 06/2025` / `depuis 06/2025` for the current role) in the 9.5rem column, then the title (1.15rem 600, Annotation Ink on hover) and summary (text capped at 46rem), the city (Label) flush right on the title line just before a small Pencil Grey chevron that flips when open. Highlights and stack open below, indented to the text column. Only the current role starts open. On narrow screens the dates move above the title, the city drops under the summary, and the detail loses its indent.

### Learning chart
The career chart's sibling in Education · Certifications, same component and label column: one row per degree (school name, 6px Slate Ink bar from start to end), one Certifications row with a 0.9rem Slate Ink tick at each certificate's month (the tick fills its month column minus 1px, so adjacent months stay separate and same-month certificates share a tick), and the year axis from the first degree to the build date. No green: nothing here is live. Hidden from assistive technology; the cells below carry the facts.

### Cells
A ruled grid: a 1px gap over Ruled Line with a 1px outer border, each cell plain paper with 1.25rem by 1.5rem padding. Used three ways:
- **Skills:** four cells (three skill groups and Languages), group name at 1.15rem 600, items in Pencil Grey.
- **Degrees:** two cells, years at cell-year size (Geist Mono 500, clamp 1.6 to 2rem, -0.03em, tabular numerals), degree at 1.3rem 700, school and city, focus in Label.
- **Certifications:** directly under the degrees (the shared border merges), four columns, year at cell-year size, name at 1.15rem 600, issuer in Label.
Four-column grids drop to two at 64rem and to one at 40rem; degrees go to one column at 40rem. The last certificate stretches to close its row, so no empty cell ever shows.

### Navigation
- Brand name at 700 and 1.2rem in Slate Ink on the left, the icon-only theme switch on the right, and the nav links centered in the space between, 2.5rem apart, at body size in Slate Ink, no underline, Annotation Ink on hover. The language switch sits last in Pencil Grey. At 52rem and below, brand and switch share the first row and the links take a centered row below.

### Detector Box (signature)
A 2px Detection Green rectangle 10px outside the portrait, with a label tab above its top-left corner (Detection Green fill, Label Ink text, Geist Mono 0.75rem, weight 500) reading `ml_engineer 0.98`. On load it contracts from 34px out to 10px and fades in over 0.7s (`cubic-bezier(0.2, 0.8, 0.2, 1)`, 0.3s delay), only when the reader allows motion. It is decorative and hidden from assistive technology.

## Do's and Don'ts

### Do:
- **Do** keep green to links, the primary action, focus rings, live status (production, current role), and the detector box.
- **Do** open every new home section with a large Title over a 1px ink rule, and cap its prose at 46rem.
- **Do** draw diagrams only from facts already in `profile.yaml` or a case study.
- **Do** use Pencil Grey at 0.9rem for metadata (dates, places, stacks, captions).
- **Do** back every screenshot or image with the Plate White plate and Ruled Line border. Diagrams are drawn directly on the paper.
- **Do** gate any motion behind `prefers-reduced-motion: no-preference`, and keep the detector lock as the only one.
- **Do** define every new color for both light and dark modes.

### Don't:
- **Don't** add shadows, cards, gradients, or tinted section backgrounds.
- **Don't** add another typeface, use Geist Mono outside data, or set text in Detection Green on paper.
- **Don't** add JavaScript beyond the theme switch; it is the only script.
- **Don't** repeat the bounding-box motif elsewhere; it is the single annotation.
- **Don't** round corners past 6px.
