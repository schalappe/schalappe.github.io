# AGENTS.md

## Project

Bilingual (English default at `/`, French at `/fr/`) portfolio of Abdallah Hakim Kone, ML engineer.
Audience: employers. Hugo with a small custom theme, no theme dependency, and one inline script (the theme switch in
`layouts/_partials/head.html`); everything else works without JavaScript. Writing lives on
Substack; there is no local blog.

## Commands

```bash
# CV PDFs (Typst), needed before `hugo server` so the CV links resolve
for lang in en fr; do
  typst compile --root . --font-path cv/fonts --input lang=$lang cv/cv.typ static/cv/abdallah-hakim-kone-cv-$lang.pdf
done

hugo server          # http://localhost:1313
hugo --gc --minify   # production build into public/
```

Requires Hugo ≥ 0.158 (CI pins 0.166.0) and Typst 0.15. CI (`.github/workflows/hugo.yml`) builds on every PR and
deploys `main` to GitHub Pages. `baseURL` comes from `hugo.toml`; never pass `--baseURL` in CI (it produced
`http://` canonicals before).

## Where content lives

- `data/profile.yaml`: single source for profile, experience, education, skills. Read by Hugo
  (`hugo.Data.profile`) and by the CV (`cv/cv.typ`). Translatable fields are `{en, fr}` maps; plain values
  are shared. Resolve them in templates with `partial "t.html" value`.
- `content/projects/<slug>/`: one bundle per project case study: `index.md` (en), `index.fr.md` (fr),
  `cover.*` (card thumbnail, and video still unless a `poster.*` exists), optional `demo.mp4` (click-to-play) and `demo_caption`, a one-line
  `result`, and `in_progress: true` until the project has measured results. `weight` sets the card order.
- `assets/covers/<slug>.svg`, `<slug>.fr.svg`, and `<slug>-results{,.fr}.svg`: sources of the diagram covers and
  results figures. After editing one, render it to the bundle's `cover.png`/`cover.fr.png` or
  `results.png`/`results.fr.png` (Hugo gives the French page its `.fr` file; transparent background, Geist loaded
  from `static/fonts/`). A `results.*` figure replaces the cover on the case study when there is no demo video:
  `"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless --hide-scrollbars --allow-file-access-from-files --force-device-scale-factor=2 --window-size=980,630 --default-background-color=00000000 --screenshot="$PWD/content/projects/<slug>/cover.png" "file://$PWD/assets/covers/<slug>.svg"`
- `i18n/{en,fr}.yaml`: interface strings.
- Typography in content and data: curly apostrophes (’) in YAML strings and front matter (Markdown bodies get them
  from Hugo's typographer). French text puts a narrow no-break space (U+202F) before `; : ! ?` and inside « ».
- `static/og.jpg`: social preview image, generated with ImageMagick from `assets/images/portrait.jpg`;
  regenerate it when the portrait or role changes.
- Never publish work metrics from BNP Paribas or Softeam projects: they rely on internal data.

## Layouts

`layouts/baseof.html` wraps every page; `home.html` is the portfolio, `page.html` a case study, `404.html`.
Partials in `layouts/_partials/`. Styles in `assets/css/main.css` (tokens at the top, light/dark from
`prefers-color-scheme`). Fonts: Geist (site and CV) and Geist Mono (site, data only), self-hosted in `static/fonts/`
and `cv/fonts/`.

## Gotcha

An editor formatter rewrites `.html` templates on save and inserts a space inside Go template strings in
attributes (`{{ i18n "x" }}` → `{{ i18n " x" }}`). Inside HTML attributes, use backtick strings
(`{{ i18n `x` }}`) or assign a variable first.
