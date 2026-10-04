// T-19 — a nested call to a flow function (documented limitation).
//
// The reflow functions split and measure their content, so a second, nested
// call cannot be discovered by the outer one: the inner call would be treated
// as an opaque block, and its own margin switch would fight with the outer one.
// This document records what happens today. See the "Limitations" section of
// the manual.
//
// A nested call is expected to compile, but its output is *not* guaranteed: the
// inner reflow measures the outer page geometry, which the outer reflow has
// already replaced.

#import "assets/harness.typ": *

#show: test-setup

#reflow(
  set-page-margin: true,
  margin: "symmetric",
  columns: (count: 2, gutter: 10pt),
  preamble: [ #lorem(40) ],
)[
  #lorem(200)

  #margin-reflow(
    columns: (count: 2, gutter: 6pt),
    margin: "symmetric",
    set-page-margin: true,
  )[
    #lorem(100)
  ]

  #lorem(200)
]

// EXPECT page=1 pages=2 ink-left=10.05mm ink-right=9.17mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=2 ink-left=10.05mm ink-right=73.56mm ink-top=17.64mm body-bottom=12.26mm cols=1
