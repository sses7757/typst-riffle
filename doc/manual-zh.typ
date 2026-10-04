#set page(paper: "a4", margin: 2.2cm, numbering: "1")
#set text(font: ("New Computer Modern", "SimSun"), size: 10.5pt, lang: "zh")
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

// 源文件中的换行会在两个汉字之间产生一个空格，因此本手册的中文段落一律不在汉字之间
// 换行。若需要在别处修复这类空格，可以套用 cjk-unbreak 的 remove-cjk-break-space；
// 注意它无法跨过 strong、footnote 等样式元素。
#import "@preview/cjk-unbreak:0.2.3": remove-cjk-break-space

// 示例源码位于包旁边；页面图片由 `scripts/render-doc-images.ps1` 生成，
// 中文版本用 `--input lang=zh` 输出到 `doc/images/zh/`。
#let source(name) = raw(read("../examples/" + name + ".typ"), lang: "typ", block: true)
#let pages(name) = grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  image("images/zh/" + name + "-1.png", width: 100%),
  image("images/zh/" + name + "-2.png", width: 100%),
)
#let example(name, title, note) = {
  heading(title)
  source(name)
  v(0.7em)
  pages(name)
  v(0.3em)
  align(center)[#text(size: 8.5pt, fill: luma(110))[
    渲染结果 —— 左为第 1 页，右为第 2 页。#note
  ]]
  v(0.6em)
}

#align(center)[
  #text(size: 26pt, weight: "bold")[riffle] \
  #v(0.3em)
  #text(size: 14pt)[在页面中途把内容重排到新的页边距] \
  #v(0.3em)
  #text(size: 11pt)[手册 · 版本 0.2.0]
]

#v(2em)

= 简介

本包把一段内容在它出现的位置直接重排到新的页边距，且*不强制换页*。它适用于混用非对称（书籍式、外侧留白较宽）版式与需要不同宽度的内容块（例如习题）的文档。

所有方向都由同一个函数完成：

```typ
#margin-reflow(
  content,
  columns: (count: 1, gutter: 4%),
  margin: auto,
  footnote-style: none,
  set-page-margin: true,
)
```

- `columns` 决定重排内容的栏数（以及栏间距）；
- `margin` 决定要切换到的页边距；
- `footnote-style` 设置由本包手动排版的脚注条目样式；
- `set-page-margin` 在快速路径（`true`，使用 `set page(...)`）与完全手工分页的路径（`false`）之间选择。

重排会把脚注从正文流中取出，在重排块底部手动排版，保留脚注编号与引用；重排块底部与可用高度齐平；并让其后的页面沿用新的页边距。它是 `context` 函数，会自行测量当前页面与位置。

= 安装

本包已发布在 Typst Universe：

```typ
#import "@preview/riffle:0.2.0": margin-reflow
```

= 使用要求

请在正常文档流中使用，并保证页面尺寸已知：页面宽高必须是具体长度。

重排内容的首行缩进跟随环境的 `par.first-line-indent`，请显式设置：

```typ
#set par(first-line-indent: (amount: 2em, all: true), justify: true)
```

= API 参考

== `margin-reflow`

把 `content` 按 `margin` 指定的页边距重排为一栏或多栏，从调用位置开始，且不会在内容之前换页。

```typ
#margin-reflow(
  content,
  columns: (count: 1, gutter: 4%),
  margin: auto,
  footnote-style: none,
  set-page-margin: true,
)
```

- `content` *（content）*：要重排的内容。会识别段落分隔，因此一个段落不会在一栏开始、在下一栏继续。
- `columns` *（dictionary，默认 `(count: 1, gutter: 4%)`）*：转发给分栏排版。只有 `count`（int，默认 `1`）和 `gutter`（length，默认为重排宽度的 `4%`）有意义。
- `margin` *（auto、length、dictionary 或 `"symmetric"`，默认 `auto`）*：要切换到的水平页边距。
  - 形如 `(inside: 1cm, outside: 3cm)` 或 `(left: 1cm, right: 3cm)` 的页边距字典；
  - 单个长度，此时左右页边距相等；
  - `"symmetric"`：把当前页面的 `min(inside, outside)` 用于两侧；
  - `auto`：沿用当前页边距。
  只取其中的水平页边距；当前页面的上下页边距保持不变。
- `footnote-style` *（none、dictionary 或 function，默认 `none`）*：手动排版脚注条目的样式。
  - `none`：沿用继承的默认样式；
  - dictionary：对每个条目的正文施加 `set text(...)`，因此可用的键是 `text` 的参数（`size`、`fill`、`style` 等）；
  - function：直接施加到每个条目的正文上。
  条目的 `gap`、`indent`、`clearance`、`separator` 取自环境中的 `footnote.entry` 设置，用 `#set footnote.entry(...)` 配置即可。
- `set-page-margin` *（bool，默认 `true`）*：新页边距的生效方式。
  - `true`：用 `set page(...)` 切换*其后*页面的页边距，只有当前页由本包手工分栏；速度快，推荐使用，且对任意 `count` 都适用。
  - `false`：完全不使用 `set page(...)`，每一页都由本包手工分栏、用内边距模拟页边距变化；速度较慢，且每页会写成一个文本块，适合不希望改动文档页面设置的场合。只允许 `count: 1`（即不写 `count`，或写 `count: 1`）：多于一个栏时，手工分页无法在页面中途切换版式，最后一页仍会按单栏填满，因此该组合会触发断言。

= 使用说明

== 脚注

脚注会从重排内容中取出，由本包排版，因此其条目与重排块对齐，而不是与页面宽度对齐。编号与 `ref` 仍然有效。条目正文的样式请用 `footnote-style` 设置，条目间距（`gap`、`indent`、`clearance`、`separator`）请用 `#set footnote.entry(...)` 设置——本包会读取环境中的这些设置。

== 首行缩进

每个分栏块都放在独立的盒子中，因此环境中的 `par.first-line-indent` 由本包显式应用：如果希望分栏块的第一个段落也缩进，请设置 `first-line-indent: (amount: ..., all: true)`。

== 页码与计数器

Typst 在排版期解析的计数器（例如 `counter(page)` 以及自定义计数器）不受影响：它们仍然按照文档顺序取值。

= 示例

下列每个示例都是完整、可编译的文件，旁边是其渲染出的两页。在页面图片中，*蓝色*虚线标记对称内容边界，*橙色*虚线标记非对称内容边界。

#example("column-flow", [非对称页面上的两栏],
  [重排内容跨两页，因此可以清楚看到其后页面的行为。])

#example("single-flow", [非对称页面上的单栏],
  [横跨对称宽度的单栏。])

#example("asymmetric-flow", [回到非对称版式],
  [从对称页边距开始，再切换到非对称页边距。])

#example("footnotes-figure", [脚注与图片],
  [在最开头放置脚注、在中间放置图片，再在中间放置脚注，全部位于重排块内。])

= 限制

== 重排函数不能嵌套使用

`margin-reflow` 会测量并重写传入的内容，并根据自身所在位置的页面状态决定版式。这样的内容里如果再出现一次调用，外层调用无法看到它：内层调用测量到的页面版式已经被外层替换，两次页边距切换也会互相冲突。请顺序调用——等第一次调用结束之后再调用 `margin-reflow`。

== 重排内容中不能使用状态更新

为了确定能放下多少内容，本包会多次排版同一段内容（在 `set-page-margin: false` 时每页一次）。因此：

- 重排内容里的 `state` 更新会执行多次，不能依赖。需要在别处读取的状态，请改用 metadata 等实现方式，而不要在重排内容里调用 `state.update()`；
- 会触发排版期效应的 `counter` 访问（`counter(footnote)`、`counter(page)`）由本包自行处理，没有问题；
- 手动更新计数器（例如 `#counter("my-counter").update(...)` 或 `.step()`）只要作为普通文档内容书写就不受影响：Typst 的计数器在排版之后解析，最终取值仍遵循文档顺序。

一句话：不要在重排内容里搭建 `state` 机制，把状态处理放在外面，再把结果传进来。

== 脚注由本包排版

重排内的脚注会被收集并手动排版，因此 Typst 自己的 `footnote.entry` 规则对它们不生效；条目正文请用 `footnote-style` 参数，条目间距请用 `#set footnote.entry(...)`。这也意味着：本应浮动到页面真正底部的脚注（例如重排内容里使用 `figure(placement: bottom)`）会由本包放置，而不是由页面放置。

== 页面设置

- 页面宽高必须是具体长度。
- `set-page-margin: false` 要求 `count: 1`；多于一个栏时该组合会被拒绝，因为手工分页的页面无法在页面中途切换到多栏版式。
- 本包会自行构建固定高度的 `grid`/`block` 结构并修改 `page.margin`，因此与同样控制分页、分栏或页面几何的包可能冲突。仅对内容做装饰（颜色、盒子、强调等）的包通常可以使用。
- `margin: auto` 沿用当前页边距；在非对称页面上，这会让重排的栏使用非对称的*宽度*，却按对称版式定位。两栏重排请传 `margin: "symmetric"`（或显式字典）；`auto` 适合"就在现有页边距内重排"的场合。

= 兼容性与中文 / CJK

== 处理内容的包

函数会拆分并重建内容，因此"*转换内容*"的包应在把内容传入*之前*先应用。例如与 `cjk-unbreak` 连用：

```typ
#import "@preview/cjk-unbreak:0.2.3": remove-cjk-break-space

#margin-reflow(
  columns: (count: 2, gutter: 10pt),
  margin: "symmetric",
)[
  #remove-cjk-break-space[
    中文与英文混排内容……
  ]
]
```

== 中文与混排

拆分器能够识别汉字、中文标点与空格，因此可以处理中文、日文、韩文文本，以及中英文混排的重排。建议设置支持中文的字体并开启两端对齐与首行缩进：

```typ
#set text(font: ("New Computer Modern", "SimSun"), lang: "zh")
#set par(first-line-indent: (amount: 2em, all: true), justify: true)
```

*源文件*中两个汉字之间的换行会被渲染成一个空格。当两侧都是纯文本时，`cjk-unbreak` 可以去掉这些空格；但如果其中一侧是 `strong`、脚注等样式元素，它无能为力。因此中文段落的换行位置应避开"不能出现空格"的地方。

== 旁注包（如 marginalia）

本包常与 `marginalia` 等旁注包连用，但由于它接管了页面并在页面中途修改 `page.margin`，需要注意以下几点：

- *不要*把 `margin-reflow` 的输出包在 `marginalia.wideblock` 中。wideblock 依据 marginalia 的配置而非当前页面页边距来计算宽度，而且多页 wideblock 在交替页边距下无法正常工作。
- *不要*用 `marginalia.wideblock` 或 `marginalia.header` 来排版页眉页脚，而应直接依据 `page.margin` 对齐，使其跟随本包设置的页边距。下例改编自书籍模板：

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

- 仍可用一个*空的* `marginalia.wideblock` 来预留被加宽的区域，从而避免旁注溢出到正文。

= 灵感来源

在页面中途重排内容的想法来自 [meander.typ](https://github.com/Vanille-N/meander.typ)。本包聚焦于"非对称 ⇄ 对称"方向的重排，尤其是以往可能[不收敛](https://github.com/Vanille-N/meander.typ/issues/1#issuecomment-3306100761)的多页非对称重排，并支持中英文混排。

名字 *riffle* 沿用这一河流隐喻：它指河流中水流性质改变的那一小段浅滩急流，这里指页面中途改变版式走向的一小段。

= 许可证

采用 MIT 许可证。
