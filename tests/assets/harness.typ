// Shared harness for the riffle test suite.
//
// Every test document is a normal, compilable Typst file:
//
//   #import "assets/harness.typ": *
//   #show: test-setup
//
//   #reflow(
//     margin: "symmetric",
//     columns: (count: 2, gutter: 10pt),
//     preamble: [ ... text before the reflow ... ],
//   )[
//     ... content handed to `margin-reflow` ...
//   ]
//
// `test-setup` installs the page geometry under test with a *show rule*, not
// with a `set page(...)` inside a function: a `set` inside a function is
// restored when the call returns, which makes the page setup depend on where
// the reflow happens to end. With a show rule the page settings are ordinary
// document-level settings, exactly as a user would write them.
//
// The expected geometry of the rendered pages is declared in the test document
// itself, with `EXPECT` comments, and checked by `tests/verify-pages.py`; see
// `tests/README.md`.

#import "../../lib.typ": margin-reflow
#import "../../examples/assets/guides.typ": guides

// ---------------------------------------------------------------- geometry ---

// Book-style (asymmetric) margin of the pages under test.
#let book-margin = (inside: 1cm, outside: 2.5cm)
// The symmetric margin the reflow normally switches to.
#let symmetric-margin = (inside: 1cm, outside: 1cm)
// A deliberately different asymmetric target.
#let other-margin = (inside: 2cm, outside: 3cm)
// Symmetric page setup used as the *starting* point of the reverse direction.
#let symmetric-page = (paper: "a5", margin: (x: 1.5cm), numbering: "1")

// Page geometry shared by most tests: an A5 book page.
#let base-page = (
  paper: "a5",
  margin: book-margin,
  numbering: "1",
)

// Guide lines drawn on the page background: blue marks the symmetric content
// boundary, orange the asymmetric one. On an A5 book page with
// margin `(inside: 1cm, outside: 2.5cm)` the boundaries are 10mm from each
// edge (symmetric) and 10mm/25mm (asymmetric).
#let guide-set = (sym: (1cm, 1cm), asym: (1cm, 2.5cm))

// ------------------------------------------------------------------- setup ---

// Document-level setup: page geometry, fonts, indentation and the plain-mode
// footnote entry settings. Apply it with `#show: test-setup.with(...)`.
//
// - `page-setup`: merged over `base-page`, e.g. `(paper: "a4")` or
//   `symmetric-page`.
// - `guide-margins`: `none` disables the guide lines; otherwise a
//   `(sym: ..., asym: ...)` margin pair for `guides`.
// - `footnote-entry`: passed to `set footnote.entry(...)` as ordinary page
//   styling, which `margin-reflow` reads for `gap`, `indent`, `clearance` and
//   `separator`.
#let test-setup(
  page-setup: (:),
  guide-margins: guide-set,
  footnote-entry: (indent: 0em),
  font: ("New Computer Modern", "SimSun"),
  size: 8pt,
  lang: "en",
  body,
) = {
  set page(..(base-page + page-setup))
  if guide-margins != none { set page(background: guides(..guide-margins)) }
  set text(font: font, size: size, lang: lang)
  set par(first-line-indent: (amount: 2em, all: true), justify: true, leading: 0.6em)
  set footnote.entry(..footnote-entry)
  body
}

// ---------------------------------------------------------------- reflowing ---

// Call `margin-reflow` with optional content before and after it. Everything
// reaches the package exactly as written here, so what the tests render is what
// a user would get.
#let reflow(
  margin: "symmetric",
  columns: (count: 2, gutter: 10pt),
  footnote-style: none,
  set-page-margin: true,
  preamble: none,
  postamble: none,
  body,
) = {
  if preamble != none { preamble }
  margin-reflow(
    columns: columns,
    margin: margin,
    footnote-style: footnote-style,
    set-page-margin: set-page-margin,
  )[#body]
  if postamble != none { postamble }
}

// ---------------------------------------------------------------- content ----

// A paragraph that ends with a footnote.
#let para-fn(words, note-text) = {
  lorem(words)
  footnote(note-text)
}

// A paragraph that *starts* with a footnote.
#let fn-para(words, note-text) = {
  footnote(note-text)
  lorem(words)
}

// The bundled vector figure.
#let test-figure(width: 70%, caption: [A figure inside the reflow.]) = figure(
  image("../../examples/assets/plot.svg", width: width),
  caption: caption,
)

// The same figure without a caption, to keep a column short.
#let bare-figure(width: 70%) = figure(
  image("../../examples/assets/plot.svg", width: width),
  caption: none,
)

// A block element, to check that block-level content survives the split.
#let test-table() = table(
  columns: 3,
  [a], [b], [c],
  [1], [2], [3],
)

// A mixed-script paragraph, for the CJK tests.
#let cjk-sample = [
  中文与英文混排 testing mixed CJK and Latin reflow across columns。
  假文假文假文假文假文假文假文假文假文假文假文假文假文假文假文。
]
