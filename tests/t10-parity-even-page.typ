// T-10 — page 2 is the first reflowed page (page parity).
//
// The reflow starts partway down page 1 and the content runs over pages 2 and
// 3, so the reflowed block lands on both an even and an odd page. With
// `inside`/`outside` margins the left/right margin swap on even pages, which is
// exactly where a padding sign error shows up as a horizontal shift.
//
// Check visually:
//   - page 1 keeps the asymmetric margins,
//   - pages 2 and 3 both use the symmetric margins (10mm on both sides),
//   - the content is *not* shifted left or right on the even page.

#import "assets/harness.typ": *

#show: test-setup

#reflow(
  set-page-margin: true,
  margin: "symmetric",
  columns: (count: 2, gutter: 10pt),
  // Enough text to push the reflow onto page 2.
  preamble: [ #lorem(200) ],
)[
  #lorem(300)

  #lorem(300)

  #lorem(300)

  #lorem(300)
]

// EXPECT page=1 pages=3 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=2 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=3 ink-left=10.05mm ink-right=73.56mm ink-top=17.64mm body-bottom=12.26mm cols=1
