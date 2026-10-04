// T-11 — explicit asymmetric margin target.
//
// `margin: (inside: 2cm, outside: 3cm)` starts from the symmetric page and
// reflows the content into a wider asymmetric area; the following pages use
// that asymmetric margin (flipped on even pages).
//
// Check visually:
//   - page 1 keeps 1.5cm on both sides,
//   - the reflowed single column of page 1 is 2cm from the left and reaches into
//     the 3cm outer margin on the right (it ends 3cm from the right edge),
//   - pages 2 and 3 use inside 2cm / outside 3cm, i.e. on the odd page 3 the
//     text ends 3cm before the right edge; on the even page 2 the wide margin is
//     on the left.

#import "assets/harness.typ": *

#show: test-setup.with(page-setup: symmetric-page)

#reflow(
  margin: other-margin,
  columns: (count: 1),
  set-page-margin: true,
  preamble: [ #lorem(60) ],
)[
  #lorem(300)

  #lorem(300)

  #lorem(300)
]

// Page 1: preamble is symmetric (16.7mm from each edge because of the 1.5cm
// margin plus the 0.17mm text lead), then the reflow switches to
// inside 2cm / outside 3cm on the following pages.

// EXPECT page=1 pages=2 ink-left=15.17mm ink-right=14.82mm ink-top=17.64mm body-bottom=12.26mm cols=1
// EXPECT page=2 ink-left=30.16mm ink-right=19.76mm ink-top=17.64mm body-bottom=12.26mm cols=1
