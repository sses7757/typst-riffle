// T-06 — footnotes on the first reflowed page (starts mid-page).
//
// Three footnotes: one at the very start of the reflowed content, one in the
// first paragraph and one in a later paragraph. The footnote area of the first
// reflowed page must be at the bottom of that page's text area, inside the
// symmetric margins, and the entries must be laid out at the reflow width
// rather than the page width.
//
// Check visually:
//   - a footnote separator near the bottom of the reflowed part of page 1,
//   - the entries starting at the left symmetric boundary,
//   - the reflowed body not overlapping the footnote area,
//   - footnote marks 1..3 in the expected order.

#import "assets/harness.typ": *

#show: test-setup

#set footnote.entry(indent: 0em)

#reflow(
  set-page-margin: true,
  margin: "symmetric",
  columns: (count: 2, gutter: 10pt),
  footnote-style: (size: 7pt),
  preamble: [ #lorem(50) ],
)[
  #fn-para(60, [Footnote at the very start of the reflow.])

  #para-fn(120, [A footnote halfway through the first page of the reflow.])

  #para-fn(120, [A footnote at the start of the following paragraph.])

  #lorem(200)

  #para-fn(200, [A footnote on a later page.])
]

// EXPECT page=1 pages=2 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=2 ink-left=10.05mm ink-right=73.56mm ink-top=17.64mm body-bottom=12.26mm cols=1
