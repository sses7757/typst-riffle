// T-03 — reflow starts in the middle of page 1, two columns,
// set-page-margin: true.
//
// The first page has already been started at the asymmetric margins, so the
// reflow has to split the content by hand for the current page, place the
// footnotes of that page itself, and only switch the page margins for the
// pages that follow.
//
// Check visually:
//   - the text above the reflow keeps the asymmetric margins (it starts 10mm
//     from the left, the wide outer margin is on the right),
//   - the reflowed columns start 10mm from the left and end 10mm from the
//     right, i.e. they are wider than the text above and stick out into the
//     outer margin,
//   - the columns reach the bottom of the page's text area.

#import "assets/harness.typ": *

#show: test-setup

#reflow(
  set-page-margin: true,
  margin: "symmetric",
  columns: (count: 2, gutter: 10pt),
  preamble: [ #lorem(60) ],
)[
  #lorem(300)

  #lorem(300)

  #lorem(300)
]

// Page 1: the preamble (asymmetric, 10mm/25.2mm) plus the reflowed block
// (symmetric), so the ink bbox is 10mm from the left and 10mm from the right.
// Pages 2..3 are fully symmetric.

// EXPECT page=1 pages=2 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=2 ink-left=10.05mm ink-right=73.56mm ink-top=17.64mm body-bottom=12.26mm cols=1
