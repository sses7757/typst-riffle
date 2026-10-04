// T-09 — footnotes *and* figures together, plus block content.
//
// The most complex content: a footnote before a figure, a figure, a footnote
// after the figure, a table, and a note on the last page. This is the case the
// manual advertises.
//
// Check visually:
//   - the footnote of a page is never placed above the figures of that page,
//   - the table stays inside its column,
//   - the last page's footnote area is at the bottom of the page.

#import "assets/harness.typ": *

#show: test-setup

#reflow(
  set-page-margin: true,
  margin: "symmetric",
  columns: (count: 2, gutter: 10pt),
  footnote-style: (size: 7pt),
  preamble: [ #lorem(30) ],
)[
  #fn-para(40, [Footnote before the figure.])

  #test-figure(width: 75%, caption: [A figure with a footnote before it.])

  #para-fn(100, [Footnote after the figure.])

  #lorem(120)

  #test-table()

  #lorem(150)

  #para-fn(150, [Footnote on a later page.])

  #lorem(100)

  #para-fn(60, [Footnote on the last page.])
]

// EXPECT page=1 pages=2 ink-left=10.05mm ink-right=9.88mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=2 ink-left=10.05mm ink-right=73.56mm ink-top=17.64mm body-bottom=12.26mm cols=1
