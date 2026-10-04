// Example: switch from symmetric margins to an asymmetric layout.
//
// Compile to page images with:
//   typst compile -f png --ppi 144 examples/asymmetric-flow.typ "doc/images/asymmetric-flow-{p}.png"
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
  margin: 1.5cm,
  numbering: "1",
  background: guides(sym: (1.5cm, 1.5cm), asym: (1cm, 2.5cm)),
)
#set text(font: ("New Computer Modern", "SimSun"), size: 9pt, lang: lang)
#set par(first-line-indent: (amount: 2em, all: true), justify: true, leading: 0.6em)

// Body text at symmetric margins.
#let preamble = if lang == "zh" { [对称页边距下的正文示例。] } else { [#lorem(40)] }

#preamble

#v(1em)

#let reflow-body = if lang == "zh" { remove-cjk-break-space[

    页面开始时是对称页边距；从这里起内容收窄，改用传给 `margin` 的非对称页边距
    （内侧 1cm、外侧 2.5cm），其后各页沿用该版式。
    #footnote[位于重排内容开头的脚注。]

    #lorem(240)

    中文与英文混排 testing mixed CJK and Latin reflow。
    假文假文假文假文假文假文假文假文假文假文假文假文假文假文假文。

    #lorem(260)
] } else {
  [
    The page starts with symmetric margins; from here on the content is narrower,
    using the asymmetric margin given to `margin` (1cm inside, 2.5cm outside),
    and the pages that follow keep that layout.
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
  margin: (inside: 1cm, outside: 2.5cm),
)[#reflow-body]
