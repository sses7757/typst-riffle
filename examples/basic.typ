// Minimal runnable example for riffle.
//
// Compile with:
//   typst compile examples/basic.typ

#import "../lib.typ": margin-reflow

#set page(paper: "a5", margin: (inside: 1cm, outside: 3cm), numbering: "1")
#set text(font: ("New Computer Modern", "SimSun"), size: 9pt, lang: "en")
#set par(first-line-indent: (amount: 2em, all: true), justify: true, leading: 0.65em)

Text before the reflow sits at the normal asymmetric margins.

#lorem(30)

#margin-reflow(
  columns: (count: 2, gutter: 10pt),
  margin: "symmetric",
)[
  #lorem(60) #footnote[A footnote inside the reflowed content.]

  #lorem(60)
]

Back at the asymmetric margins.

#lorem(30)
