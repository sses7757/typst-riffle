// T-12 — `margin: auto` starts from a symmetric page.
//
// This is the "refill the current margins" case: the page already has symmetric
// margins, so `auto` has nothing to switch and the reflow should simply lay the
// content out in two columns inside the *current* margins, without changing
// anything for the following pages.
//
// Check visually:
//   - the columns use the full 1cm/1cm text area,
//   - the preamble above the reflow is unchanged,
//   - no margin switch happens on the following pages.

#import "assets/harness.typ": *

#show: test-setup.with(page-setup: symmetric-page)

#reflow(
  margin: auto,
  columns: (count: 2, gutter: 10pt),
  set-page-margin: true,
  preamble: [ #lorem(60) ],
)[
  #lorem(300)

  #lorem(300)

  #lorem(300)
]

// EXPECT page=1 pages=2 ink-left=15.17mm ink-right=14.82mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=2 ink-left=15.17mm ink-right=14.82mm ink-top=17.64mm body-bottom=12.26mm cols=1
