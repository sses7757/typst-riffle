// T-21 — the page margin is a plain length (`#set page(margin: 1.5cm)`).
//
// The most common shorthand for symmetric margins hands `margin-reflow` a
// *length* in `page.margin`, where an `in` test or an `inside`/`outside` lookup
// would fail. The reflow must resolve such a margin the way Typst does: use it
// on all four sides.
//
// Two variants are covered: a plain length, and the `(x: ...)` dictionary.
// Both must produce the same geometry (1.5cm from every edge).
//
// Check visually: the preamble and the reflowed columns start 1.5cm from the
// left edge and end 1.5cm before the right edge, and the following pages keep
// that margin.

#import "assets/harness.typ": *

#show: test-setup

// The page setup under test: a plain-length margin.
#set page(paper: "a5", margin: 1.5cm, numbering: "1")

#lorem(60)

#reflow(
  margin: "symmetric",
  columns: (count: 2, gutter: 10pt),
)[
  #lorem(300)

  #lorem(300)

  #lorem(300)
]

// EXPECT page=1 pages=2 ink-left=15.17mm ink-right=14.82mm ink-top=14.99mm body-bottom=15.43mm cols=2
// EXPECT page=2 ink-left=15.17mm ink-right=14.82mm ink-top=14.99mm body-bottom=17.19mm cols=1
