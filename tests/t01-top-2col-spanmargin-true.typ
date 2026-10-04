// T-01 — reflow starts at the top of page 1, two columns, set-page-margin: true.
//
// The "at top" special case: the margins are switched immediately and the
// content is laid out in two columns. The content spans several pages, so the
// margin switch on the following pages is visible too.

#import "assets/harness.typ": *

#show: test-setup

#reflow(
  set-page-margin: true,
  margin: "symmetric",
  columns: (count: 2, gutter: 10pt),
)[
  #lorem(300)

  #lorem(300)

  #lorem(300)

  #lorem(300)
]

// Symmetric page: 10mm on both sides, so the ink must stay inside 10mm/138mm.
// Two columns of (128mm - 10pt)/2 ≈ 62.6mm.

// EXPECT page=1 pages=2 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=2 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=2
