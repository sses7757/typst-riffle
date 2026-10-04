// T-15 — mixed CJK / Latin reflow and `remove-cjk-break-space`.
//
// The splitter is CJK-aware, but a package that rewrites content (such as
// `cjk-unbreak`) must be applied to the content *before* it is handed to
// `margin-reflow`. This test does exactly what the manual recommends.
//
// The content spans several pages on purpose: the CJK splitter has to keep
// working on the *continuation* pages, where the text has already been cut
// between two Han characters several times.
//
// Check visually:
//   - no line starts with a closing CJK punctuation mark or ends with an
//     opening one,
//   - no stray space appears between two Han characters, including at the
//     boundaries where the text was split between pages,
//   - Latin words are not glued to the surrounding Han characters,
//   - every footnote mark has a matching entry.

#import "assets/harness.typ": *
#import "@preview/cjk-unbreak:0.2.3": remove-cjk-break-space

#let zh = remove-cjk-break-space[
  中文段落中换行会造成奇怪的空格，这是一个用于检验重排的段落。此处插入一个脚注。
  #footnote[中文脚注：换行不应产生空格。]
  混合 Latin words and numbers 12345 in the middle of a Chinese paragraph, wrapped
  to several lines by hand so that the source line breaks are not at natural
  break points. 中文标点（全角括号）也应正确处理，例如“引号”与《书名》。
]

#show: test-setup

#reflow(
  margin: "symmetric",
  columns: (count: 2, gutter: 10pt),
  footnote-style: (size: 7pt),
  preamble: [ #lorem(40) ],
)[
  #zh

  #zh

  #zh

  #zh

  #zh

  #zh

  #zh

  #zh

  #zh
]

// EXPECT page=1 pages=1 ink-left=10.05mm ink-right=10.23mm ink-top=17.64mm body-bottom=12.26mm cols=5
