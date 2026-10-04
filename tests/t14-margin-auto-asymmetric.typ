// T-14 — `margin: auto` on an asymmetric page, two columns.
//
// `auto` (the default) inherits the current margin, so on a book page the
// reflowed columns are laid out at the asymmetric width while the first column
// starts at the asymmetric left edge. This test pins down what that looks like
// over several pages: the content must not run into the *outer* margin (it may
// only use the asymmetric text width, which ends 25mm from the right edge), the
// continuation pages must keep the same geometry, and no content may be lost.
//
// The content deliberately spans multiple pages: a page-count and a
// last-page check are the only way to see whether the continuation path
// re-splits the same way the first page did.

#import "assets/harness.typ": *

#show: test-setup

#reflow(
  margin: auto,
  columns: (count: 2, gutter: 10pt),
  set-page-margin: true,
  preamble: [ #lorem(60) ],
)[
  #lorem(300)

  #lorem(300)

  #lorem(300)

  #lorem(300)

  #lorem(300)

  #lorem(300)
]

// EXPECT page=1 pages=4 ink-left=10.05mm ink-right=24.70mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=2 ink-left=25.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=3 ink-left=10.05mm ink-right=24.70mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=4 ink-left=25.05mm ink-right=66.15mm ink-top=17.64mm body-bottom=12.26mm cols=1
