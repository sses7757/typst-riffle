// T-04 — reflow starts in the middle of page 1, one column,
// set-page-margin: false.
//
// The hand-split path for *every* page: the middle pages are produced by the
// loop in `margin-reflow`, the last page by the padded "last page" branch. This
// is where off-by-one errors in the padding or the last-page handling show up,
// and it is the single-column counterpart of T-03.
//
// Check visually:
//   - the preamble keeps the asymmetric margins, the reflow runs 10mm/138mm,
//   - the following pages keep the symmetric margins,
//   - there is no empty trailing page,
//   - the text is flush to the bottom of each full page.

#import "assets/harness.typ": *

#show: test-setup

#reflow(
  set-page-margin: false,
  margin: "symmetric",
  columns: (count: 1),
  preamble: [ #lorem(60) ],
)[
  #lorem(300)

  #lorem(300)

  #lorem(300)

  #lorem(300)

  #lorem(300)
]

// EXPECT page=1 pages=3 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=1
// EXPECT page=2 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=1
// EXPECT page=3 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=1
