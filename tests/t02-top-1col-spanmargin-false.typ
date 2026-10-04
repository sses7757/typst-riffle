// T-02 — reflow starts at the top of page 1, one column,
// set-page-margin: false.
//
// The hand-split path: no `set page(...)` is used at all, every page is split by
// hand and the margin change is emulated with padding. Only `count: 1` is
// allowed here — with more than one column a hand-split page cannot switch
// layout partway through, so that combination is rejected by an assertion
// (see T-20).
//
// The rendered pages must match T-01: content inside the symmetric margins,
// starting at the top of the text area, with no extra page.
//
// Check visually:
//   - the text area is 10mm/138mm on every page,
//   - there is no empty trailing page,
//   - no paragraph is lost or repeated at a page boundary.

#import "assets/harness.typ": *

#show: test-setup

#reflow(
  set-page-margin: false,
  margin: "symmetric",
  columns: (count: 1),
)[
  #lorem(300)

  #lorem(300)

  #lorem(300)

  #lorem(300)

  #lorem(300)

  #lorem(300)
]

// EXPECT page=1 pages=3 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=1
// EXPECT page=2 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=1
// EXPECT page=3 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=1
