// Example: complex content — footnotes at the start and in the middle, and an
// image, all inside the reflowed block.
//
// Compile to page images with:
//   typst compile -f png --ppi 144 examples/footnotes-figure.typ "doc/images/footnotes-figure-{p}.png"
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
#set figure(gap: 0.5em)

// Body text at the normal asymmetric margins.
#let preamble = if lang == "zh" { [中文与英文混排的正文示例。] } else { [#lorem(40)] }

#preamble

#v(1em)

#let reflow-body = if lang == "zh" { remove-cjk-break-space[

    #footnote[位于重排内容最开头的脚注。]
    重排内容一开始就带有一条脚注。

    #lorem(220)

    #figure(image("assets/plot.svg", width: 75%), caption: [重排内容中的一张图片。])

    #footnote[位于重排内容中部的脚注。]
    下一段带有一条脚注，其后继续排布文字。

    中文与英文混排 testing mixed CJK and Latin reflow in two columns。
    假文假文假文假文假文假文假文假文假文假文假文假文假文假文假文。

    #lorem(240)
] } else {
  [
    #footnote[A footnote at the very start of the reflowed content.]
    The reflowed content starts with a footnote of its own.

    #lorem(220)

    #figure(image("assets/plot.svg", width: 75%), caption: [A figure inside the reflow.])

    #footnote[A footnote in the middle of the reflow.] The next paragraph carries
    a footnote and is followed by more text.

    Mixed scripts are split at the right places: 中文与英文混排 testing mixed CJK
    and Latin reflow in two columns.
    假文假文假文假文假文假文假文假文假文假文假文假文假文假文假文。

    #lorem(240)
  ]
}

#margin-reflow(
  columns: (count: 2, gutter: 10pt),
  margin: "symmetric",
  footnote-style: (size: 8pt),
)[#reflow-body]
