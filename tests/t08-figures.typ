// T-08 — figures inside the reflowed content.
//
// A figure at the start of the reflow, one in the middle and one near the end.
// Figures are block-level elements, so the splitter must not cut inside them and
// the rebuild step must preserve them (`_ends-block`, `_chunk-content`).
//
// Check visually:
//   - every figure stays inside its column and inside the symmetric margins,
//   - the plot is not stretched or clipped,
//   - the caption stays with the image,
//   - no text overlaps a figure.

#import "assets/harness.typ": *

#show: test-setup

#reflow(
  set-page-margin: true,
  margin: "symmetric",
  columns: (count: 2, gutter: 10pt),
  preamble: [ #lorem(40) ],
)[
  #test-figure(width: 80%, caption: [Figure at the start of the reflow.])

  #lorem(120)

  #bare-figure(width: 70%)

  #lorem(150)

  #test-figure(width: 80%, caption: [Figure in the middle of the reflow.])

  #lorem(150)

  #test-figure(width: 80%, caption: [Figure near the end of the reflow.])

  #lorem(80)
]

// EXPECT page=1 pages=2 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=2 ink-left=10.05mm ink-right=73.56mm ink-top=38.10mm body-bottom=12.26mm cols=1
