// T-07 — footnotes spread over the first, middle and last reflowed page.
//
// A long reflow (four pages) where every page carries a footnote, so the
// footnote machinery is exercised on all three code paths:
//   - the hand-split first page,
//   - the middle-page loop,
//   - the final page, whose footnote area is emitted as a
//     `figure(placement: bottom)` block.
//
// Check visually on every page:
//   - the footnote separator sits just above the entries,
//   - the entries are inside the symmetric margins,
//   - the body text stops above the footnote area (no overlap),
//   - footnote marks are numbered in document order across pages.

#import "assets/harness.typ": *

#show: test-setup

#reflow(
  set-page-margin: true,
  margin: "symmetric",
  columns: (count: 2, gutter: 10pt),
  footnote-style: (size: 7pt),
  preamble: [ #lorem(40) ],
)[
  #fn-para(80, [Footnote 1: first reflowed page.])

  #lorem(200)

  #para-fn(200, [Footnote 2: end of the first reflowed page.])

  #lorem(200)

  #para-fn(200, [Footnote 3: second reflowed page.])

  #lorem(200)

  #para-fn(200, [Footnote 4: third reflowed page.])

  #lorem(120)

  #para-fn(80, [Footnote 5: last reflowed page.])
]

// EXPECT page=1 pages=3 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=2 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=3 ink-left=10.05mm ink-right=73.56mm ink-top=17.64mm body-bottom=12.26mm cols=1
