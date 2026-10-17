// CV generated from data/profile.yaml.
// typst compile --root . --font-path cv/fonts --input lang=en cv/cv.typ static/cv/abdallah-hakim-kone-cv-en.pdf

#let lang = sys.inputs.at("lang", default: "en")
#let p = yaml("/data/profile.yaml")

#let ink = rgb("#111214")
#let muted = rgb("#5C5F66")
#let line-color = rgb("#E0E0DC")
#let accent = rgb("#2E6A12")
#let accent-graphic = rgb("#5DA327")

#let labels = (
  en: (
    experience: "Experience",
    education: "Education",
    skills: "Skills",
    languages: "Languages",
    certifications: "Certifications",
    stack: "Stack:",
    present: "Present",
    months: ("Jan.", "Feb.", "Mar.", "Apr.", "May", "June", "July", "Aug.", "Sept.", "Oct.", "Nov.", "Dec."),
  ),
  fr: (
    experience: "Expérience",
    education: "Formation",
    skills: "Compétences",
    languages: "Langues",
    certifications: "Certifications",
    stack: "Stack\u{202F}:",
    present: "Aujourd'hui",
    months: ("janv.", "févr.", "mars", "avr.", "mai", "juin", "juil.", "août", "sept.", "oct.", "nov.", "déc."),
  ),
).at(lang)

// Translatable fields are either a plain value or an {en, fr} map.
#let tr(v) = if type(v) == dictionary and lang in v { v.at(lang) } else { v }

#let fmt-date(d) = {
  if d == none { return labels.present }
  let (y, m) = str(d).split("-")
  labels.months.at(int(m) - 1) + "\u{00A0}" + y
}
#let span(start, end) = fmt-date(start) + " – " + fmt-date(end)

#let short(url) = url.replace(regex("^https?://(www\.)?"), "").trim("/", at: end)

#set document(
  title: p.name + " – " + p.role,
  author: p.name,
)
#set page(paper: "a4", margin: (x: 1.3cm, y: 0.9cm))
#set text(font: "Geist", size: 9pt, fill: ink, lang: lang)
#set par(leading: 0.42em, spacing: 0.5em)
#set list(marker: text(fill: accent-graphic)[•], indent: 0.2em, body-indent: 0.5em, spacing: 0.3em)
// yaml strings bypass smart quotes; typographic apostrophe in print.
#show "'": "’"
#show link: set text(fill: ink)

#show heading.where(level: 1): it => block(above: 0.9em, below: 0.5em, sticky: true)[
  #text(size: 11.5pt, weight: "semibold", fill: accent, tracking: 0.04em, upper(it.body))
  #v(-0.55em)
  #line(length: 100%, stroke: 0.6pt + line-color)
]

// Entry header: title + dates on line 1, subtitle + city on line 2.
#let entry-head(title, dates, sub, sub-right) = block(sticky: true, below: 0.55em, grid(
  columns: (1fr, auto),
  align: (left, right),
  row-gutter: 0.4em,
  text(weight: "bold", title), text(fill: muted, dates),
  text(fill: accent, style: "italic", sub), text(fill: muted, style: "italic", sub-right),
))

// Header
#{
  let c = p.contact
  let sep = text(fill: line-color)[#h(0.5em)|#h(0.5em)]
  grid(
    columns: (1fr, auto),
    align: (left + bottom, right + bottom),
    [
      #text(size: 22pt, weight: "bold", p.name) \
      #v(0.1em)
      #text(size: 12.5pt, weight: "semibold", fill: accent, p.role)
    ],
    text(size: 9.5pt)[
      #p.location \
      #link("tel:" + c.phone.replace(" ", ""), c.phone) \
      #link("mailto:" + c.email, c.email)
    ],
  )
  v(0.2em)
  text(size: 9.5pt, (c.website, c.github, c.linkedin).map(u => link(u, short(u))).join(sep))
}

= #labels.experience

#for (i, e) in p.experience.enumerate() {
  block(breakable: true, above: if i == 0 { 0.6em } else { 0.75em })[
    #entry-head(tr(e.role), span(e.start, e.end), e.company, e.city)
    #if "summary" in e [#tr(e.summary)]
    #if "highlights" in e { list(..tr(e.highlights)) }
    #text(size: 9pt, fill: muted)[#text(weight: "semibold", labels.stack) #e.stack.join(", ")]
  ]
}

= #labels.education

#for (i, ed) in p.education.enumerate() {
  block(breakable: false, above: if i == 0 { 0.6em } else { 0.75em })[
    #entry-head(tr(ed.degree), span(ed.start, ed.end), ed.school, ed.city)
    #text(fill: muted, tr(ed.focus))
  ]
}

= #labels.skills

#grid(
  columns: (auto, 1fr),
  column-gutter: 1em,
  row-gutter: 0.4em,
  ..p.skills.map(s => (text(weight: "semibold", tr(s.name)), tr(s.items).join(", "))).flatten(),
  text(weight: "semibold", labels.languages), p.languages.map(tr).join(", "),
)

= #labels.certifications
#grid(columns: (1fr, auto), column-gutter: 1em, row-gutter: 0.3em,
  ..p.certifications.map(c => ([#text(weight: "semibold", c.name), #text(fill: muted, c.issuer)], text(fill: muted, fmt-date(c.date)))).flatten(),
)
