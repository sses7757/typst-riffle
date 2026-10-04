// T-17 — `margin: "symmetric"` from an asymmetric page, both column counts.
//
// `"symmetric"` resolves to `min(inside, outside)` of the *current* page, so on
// an A5 page with `(inside: 1cm, outside: 2.5cm)` it must resolve to 1cm on both
// sides — identical to passing `(inside: 1cm, outside: 1cm)`.
//
// Check visually: the content must be exactly as wide as in T-03 and T-02.

#import "assets/harness.typ": *

#show: test-setup

// --- two columns -----------------------------------------------------------

#reflow(
  set-page-margin: true,
  margin: "symmetric",
  columns: (count: 2, gutter: 10pt),
  preamble: [ #lorem(40) ],
)[
  #lorem(300)

  #lorem(300)
]

#pagebreak()

// --- one column ------------------------------------------------------------

#reflow(
  set-page-margin: true,
  margin: "symmetric",
  columns: (count: 1),
  preamble: [ #lorem(40) ],
)[
  #lorem(300)

  #lorem(300)
]

// EXPECT page=1 pages=2 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=2 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=1
