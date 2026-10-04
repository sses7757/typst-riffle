// T-18 — how full the last reflowed page is.
//
// The last page of a reflow is where the sequential column filling shows: the
// first column is filled to the bottom of the page and the second one takes the
// remainder, so a nearly empty second column is expected and not a defect (see
// the manual, "Limitations"). What must *not* happen is content past the bottom
// of the text area, or a lost paragraph.
//
// Two runs are placed one after the other, each with the same preamble:
//   - run 1: enough content for several full pages,
//   - run 2: content that exactly fills its last page.
//
// Check visually:
//   - no page has its last text line below the bottom of the text area,
//   - the last full page has both columns ending near the bottom,
//   - neither run loses its final paragraph.

#import "assets/harness.typ": *

#show: test-setup

#reflow(
  margin: "symmetric",
  columns: (count: 2, gutter: 10pt),
  preamble: [ #lorem(40) ],
)[
  #lorem(300)

  #lorem(300)

  #lorem(300)

  #lorem(300)

  #lorem(300)
]

#pagebreak()

#reflow(
  margin: "symmetric",
  columns: (count: 2, gutter: 10pt),
  preamble: [ #lorem(40) ],
)[
  #lorem(300)

  #lorem(300)

  #lorem(120)

  #lorem(30)
]

// EXPECT page=1 pages=5 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=2 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=3 ink-left=10.05mm ink-right=73.56mm ink-top=17.64mm body-bottom=12.26mm cols=1
// EXPECT page=4 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=5 ink-left=10.05mm ink-right=73.56mm ink-top=17.64mm body-bottom=12.26mm cols=1
