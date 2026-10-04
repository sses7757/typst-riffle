// Example: one column across the symmetric width on an asymmetric page.
//
// Compile to page images with:
//   typst compile -f png --ppi 144 examples/single-flow.typ "doc/images/single-flow-{p}.png"
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

    把 `count` 设为 1 时，重排后的内容占据一整栏，横跨整个对称内容宽度，而不再分成两栏。
    #footnote[位于重排内容开头的脚注。]

    #lorem(240)

    中文与英文混排 testing mixed CJK and Latin reflow。
    假文假文假文假文假文假文假文假文假文假文假文假文假文假文假文。

    #lorem(260)
] } else {
  [
    With `count: 1` the reflowed content occupies a single column that spans the
    whole symmetric content width, instead of being split in two.
    #footnote[A footnote at the start of the reflowed content.]

    #lorem(240)

    Mixed scripts are split at the right places: 中文与英文混排 testing mixed CJK
    and Latin reflow.
    假文假文假文假文假文假文假文假文假文假文假文假文假文假文假文。

    #lorem(260)
  ]
}

#margin-reflow(
  columns: (count: 1),
  margin: "symmetric",
)[#reflow-body]
