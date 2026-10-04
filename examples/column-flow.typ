// Example: two columns across the symmetric width on an asymmetric page.
//
// Compile to page images with:
//   typst compile -f png --ppi 144 examples/column-flow.typ "doc/images/column-flow-{p}.png"
//
// The prose switches to Chinese when compiled with `--input lang=zh`, which is
// how `doc/manual-zh.typ` renders its figures.

#import "../lib.typ": margin-reflow
// Removes the spaces that source line breaks would otherwise insert between
// CJK characters.
#import "@preview/cjk-unbreak:0.2.3": remove-cjk-break-space
#import "assets/guides.typ": guides

#let lang = sys.inputs.at("lang", default: "en")

#set page(
  paper: "a5",
  margin: (inside: 1cm, outside: 2.5cm),
  numbering: "1",
  background: guides(),
)
#set text(font: ("New Computer Modern", "SimSun"), size: 9pt, lang: lang)
#set par(first-line-indent: (amount: 2em, all: true), justify: true, leading: 0.6em)

// Body text at the normal asymmetric margins.
#let preamble = if lang == "zh" { [中文与英文混排的正文示例。] } else { [#lorem(45)] }

#preamble

#v(1em)

#let reflow-body = if lang == "zh" { remove-cjk-break-space[

    重排从这里开始，此时页面仍处于非对称页边距之下。`margin-reflow` 会把随后的内容
    排入横跨对称宽度的两栏，并让其后的页面沿用该页边距。
    #footnote[位于重排内容开头的脚注。]

    #lorem(230)

    中文与英文混排 testing mixed CJK and Latin reflow across columns。
    假文假文假文假文假文假文假文假文假文假文假文假文假文假文假文。

    #lorem(250)
] } else {
  [
    The reflow starts here, partway down an asymmetric page. `margin-reflow` lays
    the following content out in two columns across the full symmetric width and
    keeps those margins for the pages that follow.
    #footnote[A footnote at the start of the reflowed content.]

    #lorem(230)

    Mixed scripts are split at the right places: 中文与英文混排 testing mixed CJK
    and Latin reflow across columns.
    假文假文假文假文假文假文假文假文假文假文假文假文假文假文假文。

    #lorem(250)
  ]
}

#margin-reflow(
  columns: (count: 2, gutter: 10pt),
  margin: "symmetric",
)[#reflow-body]
