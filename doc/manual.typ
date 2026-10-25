#set page(paper: "a4", margin: 2.2cm, numbering: "1")
#set text(font: ("New Computer Modern", "SimSun"), size: 10.5pt, lang: "en")
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.1")
#show raw.where(block: true): set text(size: 8.5pt)
#show raw.where(block: true): it => block(
  fill: luma(248),
  inset: 8pt,
  radius: 2pt,
  width: 100%,
  it,
)

// The example sources live next to the package; the page images are rendered
// from them by `scripts/render-doc-images.ps1` (English this way, Chinese into
// `doc/images/zh/` with `--input lang=zh`).
#let source(name) = raw(read("../examples/" + name + ".typ"), lang: "typ", block: true)
#let pages(name) = grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  image("images/" + name + "-1.png", width: 100%),
  image("images/" + name + "-2.png", width: 100%),
)
#let example(name, title, note) = {
  heading(title)
  source(name)
  v(0.7em)
  pages(name)
  v(0.3em)
  align(center)[#text(size: 8.5pt, fill: luma(110))[
    Rendered output — page 1 (left) and page 2 (right). #note
  ]]
  v(0.6em)
}

#align(center)[
  #text(size: 26pt, weight: "bold")[riffle] \
  #v(0.3em)
  #text(size: 14pt)[Reflow content into new margins in the middle of a page] \
  #v(0.3em)
  #text(size: 11pt)[Manual · version 0.2.1]
]

#v(2em)

= Introduction

This package reflows a stream of content into new page margins, starting exactly
where the content appears and *without forcing a page break*. It is designed for
documents that mix an asymmetric (book-style, wide outer margin) layout with
blocks that read better at a different width.

One function covers every direction:

```typ
#margin-reflow(
  content,
  columns: (count: 1, gutter: 4%),
  margin: auto,
  footnote-style: none,
  set-page-margin: true,
)
```

- `columns` chooses the number of columns (and the gutter) of the reflowed
  content,
- `margin` chooses the margins to switch to,
- `footnote-style` styles the footnote entries, which the reflow lays out
  itself,
- `set-page-margin` chooses between the fast path (`true`, using
  `set page(...)`) and the fully hand-split path (`false`).

The reflow pulls footnotes out of the flow and renders them at the bottom of the
reflowed block, preserves footnote numbering and `ref`s, lays the reflowed block
flush to the bottom of the available height, and keeps the new margins on the
pages that follow. It is a `context` function, so it inspects the current page
geometry and position itself.

= Installation

The package is available on Typst Universe:

```typ
#import "@preview/riffle:0.2.1": margin-reflow
```

= Requirements

Use the function in normal document flow, on pages whose size and margins are
known: the page width and height must be concrete lengths.

The first-line indentation of the reflowed content follows the ambient
`par.first-line-indent`, so set it explicitly:

```typ
#set par(first-line-indent: (amount: 2em, all: true), justify: true)
```

= API reference

== `margin-reflow`

Reflows `content` into one or more columns with the margins given by `margin`,
starting at the position where the function is called and without starting a new
page before the content.

```typ
#margin-reflow(
  content,
  columns: (count: 1, gutter: 4%),
  margin: auto,
  footnote-style: none,
  set-page-margin: true,
)
```

- `content` *(content)*: the content to reflow. Paragraph breaks are honored, so
  a paragraph never starts in one column and continues in the next.
- `columns` *(dictionary, default `(count: 1, gutter: 4%)`)*: forwarded to the
  column layout. Only `count` *(int, default `1`)* and `gutter` *(length,
  default `4%` of the reflow width)* are meaningful.
- `margin` *(auto, length, dictionary or `"symmetric"`, default `auto`)*: the
  horizontal margin to switch to.
  - a page-margin dictionary such as `(inside: 1cm, outside: 3cm)` or
    `(left: 1cm, right: 3cm)`,
  - a plain length, which yields equal left/right margins,
  - `"symmetric"`, which uses `min(inside, outside)` of the current page on both
    sides,
  - `auto`, which inherits the current page margin.
  Only the horizontal margins are taken from this value; the top and bottom
  margins of the current page are preserved.
- `footnote-style` *(none, dictionary or function, default `none`)*: styling for
  the manually laid-out footnote entries.
  - `none`: the inherited defaults,
  - a dictionary: applied as `set text(...)` to the body of each entry, so it
    takes `text`'s arguments such as `size`, `fill` or `style`,
  - a function: applied to the body of each entry directly.
  The `gap`, `indent`, `clearance` and `separator` of the entries are taken from
  the ambient `footnote.entry` settings, so configure those with
  `#set footnote.entry(...)` as usual.
- `set-page-margin` *(bool, default `true`)*: how the new margins are applied.
  - `true`: the margins of the pages *after* the reflow are switched with
    `set page(...)`; only the current page is split by hand. Fast, and the
    recommended default. Works with any `count`.
  - `false`: no `set page(...)` is used at all, so every page is split by hand
    and the margin change is emulated with padding. Slower, and it writes one
    text block per page, which is useful when the document's page settings must
    not change. Only `count: 1` (`columns` without `count`, or `count: 1`) is
    allowed: with more than one column the hand-split path cannot change the
    layout within a page, so the last page would still be filled as a single
    column. The combination is rejected with an assertion.

= Usage notes

== Footnotes

Footnotes are removed from the reflowed content and rendered by the package, so
their entries line up with the reflowed block instead of the page width.
Numbering and `ref`s keep working. Use `footnote-style` to style the body of the
entries, and `#set footnote.entry(...)` for their spacing (`gap`, `indent`,
`clearance`, `separator`), which the package reads from the ambient settings.

== First-line indentation

Each column chunk is placed in its own box, so the ambient
`par.first-line-indent` is applied explicitly by the package: set
`first-line-indent: (amount: ..., all: true)` if the first paragraph of a chunk
should be indented too.

== Page numbers and counters

The counters Typst resolves at layout time, such as `counter(page)` and custom
counters, are unaffected: they follow document order across the reflow.

= Examples

Each example below is a complete, compilable file. Its two rendered pages are
shown next to it. In the page images, the *blue* dashed line marks the symmetric
content boundary and the *orange* dashed line the asymmetric one.

#example("column-flow", [Two columns on an asymmetric page],
  [The reflowed content spans two pages, so the behaviour on the following pages
  is visible.])

#example("single-flow", [One column on an asymmetric page],
  [A single column across the symmetric width.])

#example("asymmetric-flow", [Returning to an asymmetric layout],
  [Starting from symmetric margins and switching to asymmetric ones.])

#example("footnotes-figure", [Footnotes and a figure],
  [A footnote at the very start, a figure in the middle, and a second footnote,
  all inside the reflowed block.])

= Limitations

== The flow functions cannot be nested

A `margin-reflow` call measures and rewrites the content it is given, and it
decides the page geometry from the page state at the position where it appears. A
second call *inside* that content cannot be seen by the outer call: the inner
call would measure a page whose geometry the outer call has already replaced, and
the two margin switches would compete. Keep the calls sequential — call
`margin-reflow` again after the first call has ended.

== State updates are not supported inside the reflowed content

The content is laid out several times while the package searches for the amount
that fits (and, with `set-page-margin: false`, once per page). Because of that:

- `state` updates inside the reflowed content run more than once and must not be
  relied upon. A `state` that is *read* elsewhere should be maintained with a
  metadata-based mechanism instead, not by calling `state.update()` inside the
  reflow;
- `counter` access that triggers layout-time effects (`counter(footnote)`,
  `counter(page)`) is handled by the package itself and is fine;
- a manual counter update, such as `#counter("my-counter").update(...)` or
  `.step()`, is *not* affected by the repeated layout when it is written as
  plain document content: Typst's counters are resolved after layout, so the
  final value follows document order.

In short: do not build a `state` machine inside the reflowed content. Do the
state handling outside and pass the result in.

== Footnotes are rendered by the package

Footnotes inside the reflow are collected and laid out manually. Typst's own
`footnote.entry` rules therefore do not apply to them; use the `footnote-style`
parameter for the entry body and `#set footnote.entry(...)` for the spacing. This
also means that a footnote that should float to the real bottom of the page (for
example with `figure(placement: bottom)` inside the reflow) is placed by the
package and not by the page.

== Page setup

- The page width and height must be concrete lengths.
- `set-page-margin: false` requires `count: 1`; with two or more columns the
  combination is rejected, because a hand-split page cannot switch to a
  multi-column layout partway through.
- The package builds its own fixed-height `grid`/`block` structure and changes
  `page.margin`, so layout packages that also control pagination, columns or
  page geometry may conflict. Packages that only *decorate* content (colours,
  boxes, emphasis) generally work.
- `margin: auto` inherits the current margin, which on an asymmetric page means
  the reflowed columns span the asymmetric *width* while being positioned for a
  symmetric layout. Pass `margin: "symmetric"` (or an explicit dictionary) for a
  two-column reflow; `auto` is intended for reflowing inside the margins you
  already have.

= Compatibility and CJK

== Content-processing packages

The function splits and rebuilds content, so packages that *transform content*
should be applied to the content *before* it is passed in. For example, with
`cjk-unbreak`:

```typ
#import "@preview/cjk-unbreak:0.2.3": remove-cjk-break-space

#margin-reflow(
  columns: (count: 2, gutter: 10pt),
  margin: "symmetric",
)[
  #remove-cjk-break-space[
    中文与英文混排 content ...
  ]
]
```

== CJK and mixed scripts

The splitter is aware of Han characters, CJK punctuation and spaces, so it
handles Chinese, Japanese and Korean text as well as mixed CJK/Latin reflow. For
best results, set a CJK-capable font and enable justification and first-line
indentation:

```typ
#set text(font: ("New Computer Modern", "SimSun"), lang: "zh")
#set par(first-line-indent: (amount: 2em, all: true), justify: true)
```

A line break in the *source* between two CJK characters is rendered as a space.
`cjk-unbreak` removes those spaces when the two sides are plain text; it cannot
do so across a styled element such as `strong` or a footnote. Keep the line
breaks of a CJK paragraph out of the places where a space must not appear.

== Margin-note packages (e.g. marginalia)

Using this package together with a margin-note package such as `marginalia` is a
common case, but because it manages the page and changes `page.margin` mid-page,
a few precautions are needed:

- Do *not* wrap the output of `margin-reflow` in `marginalia.wideblock`. A
  wideblock computes its width from the marginalia configuration rather than from
  the current page margins, and a multi-page wideblock does not work with
  alternating margins.
- Do *not* use `marginalia.wideblock` or `marginalia.header` for headers and
  footers. Instead, align the header/footer directly from `page.margin` (a
  broader alignment that follows the margins this package sets). A minimal
  example adapted from the book template:

  ```typ
  #set page(header: context {
    let m = page.margin
    let pad-fn = if "inside" in m {
      if calc.even(here().page()) {
        pad.with(left: m.inside - m.outside, rest: 0pt)
      } else {
        pad.with(right: m.inside - m.outside, rest: 0pt)
      }
    } else {
      it => it
    }
    pad-fn(align(end + horizon)[#counter(page).display()])
  })
  ```

- An *empty* `marginalia.wideblock` may still be used to reserve the widened area
  so that margin notes do not overflow into the body text.

= Inspiration

The idea of reflowing content mid-page comes from
[meander.typ](https://github.com/Vanille-N/meander.typ). This package focuses on
the asymmetric ⇄ symmetric reflow direction and, in particular, on the multi-page
asymmetric case that could previously fail to
[converge](https://github.com/Vanille-N/meander.typ/issues/1#issuecomment-3306100761).
It also supports mixed CJK and Latin reflow.

The name *riffle* stays with the river metaphor: a riffle is the short stretch of
a stream where the current changes character — here, the stretch of a page where
the layout changes course.

= License

Licensed under the MIT license.
