# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Primary: technical hiring managers and ML/engineering leads evaluating Abdallah Hakim Kone (Hakim Kone) as a candidate. They read case studies and open the code to judge engineering depth: how he frames a problem, what he actually built, how he measures results, and whether he admits limits. Many arrive from LinkedIn or the CV.

## Product Purpose

A bilingual personal portfolio (English default at `/`, French at `/fr/`) for an ML engineer. Success is a credibility check: the visitor leaves convinced the engineering is solid. Contact (email) and CV download are available but are not the primary success measure.

## Positioning

"I take machine learning models to production and keep them running." The distinct mechanism is the bridge between infrastructure/network work and data science: a background spanning system and network administration, software development, and ML. Production work (BNP Paribas, Softeam) is confidential, so personal projects, built end to end, carry the public proof, while experience entries describe the production work without metrics.

## Operating Context

- Visitors read on desktop and mobile, often after the CV or LinkedIn.
- Case studies follow a fixed structure: Problem, Approach, What I built, Results, Limitations and next steps; each links to its GitHub repo.
- Writing lives on Substack (no local blog); photography lives on a separate site.
- The CV PDF (Typst) is generated from the same data as the site.

## Capabilities and Constraints

- Hugo static site, small custom theme, no theme dependency. The only JavaScript is a small inline light/dark switch; the site works fully without it. Deployed to GitHub Pages.
- `data/profile.yaml` is the single source for profile, experience, education, skills; shared by the site and the CV.
- Every content and interface string exists in English and French.
- Projects are page bundles with cover image, optional click-to-play demo video and caption.
- The phone number is CV-only, never rendered on the website.

## Brand Commitments

- Name: Abdallah Hakim Kone; short name Hakim Kone; role Machine Learning Engineer; Rennes, France.
- Voice: plain, factual, first person; states results with numbers and owns failures (e.g. the cosine bug in the image-retrieval study).
- Portrait (`assets/images/portrait.jpg`) and social preview (`static/og.jpg`) exist.

## Evidence on Hand

- Four case studies in `content/projects/`: image retrieval (2023), MiniGrid agents (2025), MuZero 2048, watermarking; with repos, covers, and some demo recordings.
- Experience, education, skills, and seven certifications in `data/profile.yaml`.
- Never publish work metrics from BNP Paribas or Softeam projects: they rely on internal data. No testimonials, employer logos, or client names beyond what profile.yaml states; do not fabricate any.

## Product Principles

1. Proof over claims: every assertion should be traceable to a case study, repo, or dated experience.
2. Depth rewards the reader who stays: case studies are the core, not decoration.
3. Honesty is a signal: limitations and mistakes stay visible.
4. Confidentiality is absolute for employer work.
5. Both languages are first-class.
