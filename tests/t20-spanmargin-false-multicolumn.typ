// T-20 — `set-page-margin: false` with more than one column is rejected.
//
// A hand-split page cannot switch to a multi-column layout partway through: the
// last page would still be filled as a single column, so the result would not
// mean what the caller asked for. `margin-reflow` therefore asserts that
// `set-page-margin: false` is only used with `count: 1`.
//
// This document is expected to fail to compile; `run.ps1` checks that it does
// and that the message is the expected one. T-02 and T-04 cover the accepted
// single-column case.
//
// COMPILE-FAIL must-contain: cannot use set-page-margin == false when # columns > 1

#import "assets/harness.typ": *

#show: test-setup

#reflow(
  set-page-margin: false,
  margin: "symmetric",
  columns: (count: 2, gutter: 10pt),
)[
  #lorem(300)

  #lorem(300)
]
