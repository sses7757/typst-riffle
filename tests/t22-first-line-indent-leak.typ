// T-22 — the first line of the continuation page is shifted left by one indent.
//
// Reproduces the reported bug: when the chunk that fills the first page ends
// exactly at the end of a paragraph, the `h(-amt)` that the package prepends for
// a *continued* paragraph leaks to the next page and is rendered at the start of
// its first line, which therefore starts `par.first-line-indent.amount` left of
// the text area.
//
// Measured (A5, 8pt, 2em indent, text area at x = 28.35pt):
//   page 2, line 1 : x = 12.35pt   (= 28.35 - 16pt = 28.35 - 2em)
//   page 2, line 2+: x = 28.35pt
//
// This file is the minimal reproduction: the reflow content ends with a
// footnote-ending paragraph and nothing follows inside `[...]`.
// `tests/README.md` documents what was measured about the trigger.

#import "assets/harness.typ": *

#show: test-setup

#set footnote.entry(indent: 0em)

#reflow(
  set-page-margin: true,
  margin: "symmetric",
  columns: (count: 2, gutter: 10pt),
  preamble: [ #lorem(50) ],
)[
  #fn-para(60, [F1])

  #para-fn(120, [F2])

  #para-fn(120, [F3])

  #lorem(200)

  #para-fn(200, [F4])
]

// EXPECT page=1 pages=2
// EXPECT page=2 ink-left=10.05mm
