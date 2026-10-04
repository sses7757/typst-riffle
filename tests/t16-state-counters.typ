// T-16 — `counter` and `state` inside the reflowed content.
//
// `margin-reflow` lays its content out more than once while it determines how
// much fits, so anything with a side effect inside the reflowed content is a
// risk. The counters Typst resolves after layout are documented not to be
// affected; this test is the evidence: a custom counter stepped once per
// paragraph must end up with exactly one increment per paragraph, in document
// order, and the page numbers must follow real page order.
//
// The content deliberately spans several pages so that both the first-page
// split and the continuation path are covered.
//
// Check visually:
//   - the printed marks count 1, 2, 3, … with no repeats or gaps, in document
//     order across the columns and pages,
//   - the last mark equals the number of tagged paragraphs,
//   - the page numbers shown in the blue text follow real page order.

#import "assets/harness.typ": *

#let marker = counter("t17-marker")
#let paragraphs = 12

#let tagged(words) = {
  marker.step()
  [#lorem(words)#h(0.3em)#text(fill: blue)[[mark #context marker.display()]]]
}

#show: test-setup

#reflow(
  margin: "symmetric",
  columns: (count: 2, gutter: 10pt),
  preamble: [
    #lorem(40)
    #text(fill: blue)[[page #context counter(page).display() before the reflow]]
  ],
  postamble: [
    The reflow stepped the custom counter #context marker.display() time(s) for
    #paragraphs paragraph(s). Page after the reflow: #context counter(page).display().
  ],
)[
  #for _ in range(paragraphs) {
    tagged(200)
    parbreak()
  }
]

// EXPECT page=1 pages=5 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=2 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=3 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=12.26mm cols=2
// EXPECT page=4 ink-left=10.05mm ink-right=9.70mm ink-top=17.64mm body-bottom=20.19mm cols=2
// EXPECT page=5 ink-left=10.23mm ink-right=25.23mm ink-top=17.64mm body-bottom=12.26mm
