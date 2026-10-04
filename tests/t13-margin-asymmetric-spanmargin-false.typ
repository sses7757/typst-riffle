// T-13 — `set-page-margin: false` with an explicit asymmetric margin target.
//
// The hand-split path must also work when the target margin is asymmetric
// (inside 2cm / outside 3cm) *and* the page parity flips between the pages.
// `_get-padding` mirrors the padding on even pages, so a sign error shows up as
// content shifted the wrong way on page 2.

#import "assets/harness.typ": *

#show: test-setup.with(page-setup: symmetric-page)

#reflow(
  margin: other-margin,
  columns: (count: 1),
  set-page-margin: false,
  preamble: [ #lorem(60) ],
)[
  #lorem(300)

  #lorem(300)

  #lorem(300)
]

// EXPECT page=1 pages=2 ink-left=15.17mm ink-right=14.82mm ink-top=17.64mm body-bottom=12.26mm cols=1
// EXPECT page=2 ink-left=30.16mm ink-right=19.76mm ink-top=17.64mm body-bottom=12.26mm cols=1
