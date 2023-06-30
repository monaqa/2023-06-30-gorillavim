#import "./typst_slide.typ": slide, section, fonts, colors

#let egcode(
inset: (x: 5pt),
body
) = {
  set text(16pt, font: ("Hack Nerd Font", "IBM Plex Sans JP"))
  set block(spacing: 0.65em)
  box(
    fill: rgb("#f3eede"),
    outset: (x: 0pt, y: 0.30em),
    inset: inset,
    body
  )
}

#let egcodeblock(
body
) = {
  set text(16pt, font: ("Hack Nerd Font", "IBM Plex Sans JP"))
  block(
    width: 100%,
    fill: rgb("#f3eede"),
    outset: (x: 0pt, y: 0.30em),
    body
  )
}

#let csr(body) = {
  box(
    fill: rgb("#caced8"),
    outset: (x: 0pt, y: 0.20em),
    body
  )
}

#let cemph(body) = {
  text(fill: colors.red.darken(15%), body)
}

#let harrow(
  length: 80pt,
  margin: 0pt,
  upper_text: []
) = {
  let half_line_width = 1.5pt
  let half_beak_width = 4.5pt
  let arrow = polygon(
    fill: colors.fg.lighten(35%),
    (0pt, half_line_width),
    (length - half_beak_width, half_line_width),
    (length - half_beak_width, half_beak_width),
    (length, 0pt),
    (length - half_beak_width, -half_beak_width),
    (length - half_beak_width, -half_line_width),
    (0pt, -half_line_width),
  )
  box(
    baseline: 0pt,
    inset: (x: margin),
    align(
      center,
      stack(
        dir: ttb,
        text(size: 0.85em, upper_text),
        8pt,
        arrow,
      )
    )
  )
}

#let chalign(body) = align(center, block(align(bottom, body)))

#let statement(inset: (y: 10pt), body) = align(center, block(
  width: 100%,
  fill: colors.bg_green.lighten(75%),
  inset: inset,
  body
))

#show: slide.with(
  title: [
    Neovim プラグイン \
    dial.nvim の紹介
  ],
  author: [monaqa],
  date: [2023年6月30日],
)

= 自己紹介

#set terms(spacing: 25pt)

#grid(
  columns: (1fr, auto),
  [
/ 名前: monaqa

/ GitHub: #link("https://github.com/monaqa")[\@monaqa]

/ Bluesky: #link("https://bsky.app/profile/monaqa.bsky.social")[monaqa.bsky.social]

/ テキストエディタ: Neovim（4年半）

/ よく書く言語: Python, Rust, Lua, TypeScript

/ 最近の Vim 活: #link("https://vim-jp.org/ekiden/")[Vim 駅伝]で記事を書くなど

/ 好きな Vim キーバインド: `f`, `t`,
    #box(stroke: (bottom: 2pt + colors.red), outset: (bottom: 10pt))[`<C-a>`, `<C-x>` #place(top, dx: 30pt, dy: 35pt, [#text(14pt, fill: colors.red)[#strong[今日のお話]]])]
  ],
  image("fig/logo-190727.jpg", height: 150pt)
)

#let egblock(body) = align(
  center,
  block(
    width: 100%,
    fill: colors.bg.lighten(40%),
    inset: 5pt,
    outset: 5pt,
    radius: 10pt,
    body
))

= Vim では数値の増減が簡単にできる

- NORMAL モードで `<C-a>` や `<C-x>` を押すだけ

  - `<C-a>`: カーソル上の（またはカーソル後の）数字を 1 増やす

    #egblock[
      #egcode[ゴリラ.vim \#2#csr[7]]
      #harrow(upper_text: [`<C-a>`], margin: 20pt)
      #egcode[ゴリラ.vim \##cemph[2#csr[8]]]
    ]


  - `<C-x>`: カーソル上の（またはカーソル後の）数字を 1 減らす

    #egblock[
      #egcode[font-size: 1#csr[0]px;]
      #harrow(upper_text: [`<C-x>`], margin: 20pt)
      #egcode[font-size: #cemph[#csr[9]]px;]
    ]

#v(15pt)

- 同じ行にあれば、カーソルより右の数字を見つけて自動で移動してくれる

  #egblock[
    #egcode[#csr[ブ]レーキランプ 5回点滅]
    #harrow(upper_text: [`<C-a>`], margin: 20pt)
    #egcode[ブレーキランプ #csr[6]回点滅]
  ]


= `<C-a>` / `<C-x>` の便利なところ

- *カウント*：数字を前置して増減値を変更できる

  #egblock[
    #egcode[12#csr[3]]
    #harrow(length: 100pt, upper_text: [`20<C-a>`])
    #egcode[#cemph[14#csr[3]]]
    //
    #h(40pt)
    //
    #egcode[0x3#csr[2]]
    #harrow(length: 100pt, upper_text: [`10<C-x>`])
    #egcode[#cemph[0x2#csr[8]]]
  ]

- *ドットリピート*：`.` で直前の増減操作を繰り返せる

  #egblock[
    #set align(center + bottom)
    #grid(
      columns: 5,
      column-gutter: 5pt,
      row-gutter: 20pt,
    )[
      #egcode[#csr[4]px 12px red;]
    ][
      #harrow(upper_text: [`5<C-a>`])
    ][
      #egcode[#cemph[#csr[9]]px 12px red;]
    ][
      #harrow(length: 50pt, upper_text: [`.`])
    ][
      #egcode[#cemph[1#csr[4]]px 12px red;]
    ][
    ][
      #set align(right)
      #harrow(length: 50pt, upper_text: [`w`])
    ][
      #egcode[14px #csr[1]2px red;]
    ][
      #harrow(length: 50pt, upper_text: [`.`])
    ][
      #egcode[14px #cemph[1#csr[7]]px red;]
    ]
  ]

- *連番作成*: VISUAL モードで `g<C-a>` と押すと連番が作成できる

  #egblock[
    #egcode(inset: (x: 10pt))[
      #csr[
      #[0]. aaa

      #[0]. bbb

      #[0]. ccc
      ]
    ]
    #harrow(length: 100pt, upper_text: [`g<C-a>`])
    #egcode(inset: (x: 10pt))[
      #cemph[#csr[1]]. aaa

      #cemph[2]. bbb

      #cemph[3]. ccc
    ]
  ]

#for layer in (1, 2) [

  = 増減したいものはこの世にたくさんある

  #let lr = sym.arrow.l.r.long

  #align(center)[
  #grid(
  columns: (45%, 45%),
  column-gutter: 5%,
  row-gutter: 10pt,
  ..(
    [
      == 整数

      `0` #lr `1` #lr `2` #lr ... #lr `10` #lr ...

      `0x00` #lr `0x01` #lr ... #lr `0x0f` #lr ...
    ],
    [
      == 小数

      ... #lr `0.99` #lr `1.00` #lr `1.01` #lr ...

      ... #lr `9.9` #lr `10.0` #lr `10.1` #lr ...
    ],
    [
      == 日付・時刻

      `2022-06-30`,
      `06/30/2022`,

      `2022年06月30日`,
      `6/30`,
      ...
    ],
    [
      == 固定文字列

      `true` #lr `false`

      `月` #lr `火` #lr `水` #lr ... #lr `土` #lr `日`
    ],
    [
      == Semantic Version
    
      `3.8.12` #sym.arrow.r `3.8.13` #sym.arrow.r.double `3.9.0`
    ],
    // [
    //   == 識別子の命名規則
    //
    //   `fooBar` #lr `foo_bar` #lr `FooBar`
    // ],
    [
      == Markdown ヘッダのレベル

      `#` #lr `##` #lr `###` #lr ... #lr `######`
    ],
    ).enumerate().map(((idx, body)) => align(center, block(
      width: 100%,
      fill: if (layer == 2 and idx != 0) {
        colors.fg.lighten(75%)
      } else {
        colors.red.lighten(75%)
      },
      inset: (x: 10pt, y: 10pt),
      radius: 5pt,
      body
    )))
  )
  ]

  #if layer == 2 [
    #place(center + bottom, statement[
      標準でのサポートは基本的に整数のみ
      // *すべて dial.nvim で実現できます*
    ])
  ]

]

= そこで dial.nvim

#align(center + horizon)[
  #set text(16pt, font: ("Hack Nerd Font", "IBM Plex Sans JP"), weight: "bold")
  #link("https://github.com/monaqa/dial.nvim")[#image("fig/dial.nvim.svg")]
  #link("https://github.com/monaqa/dial.nvim")

  （必要な環境: Neovim 0.6.1 以上）
]

= dial.nvim が提供するもの

#grid(columns: (1fr, 380pt))[
- 様々なテキストの増減
  - 整数
  - 小数
  - 日付・時刻
  - 固定文字列
  - Semantic Version
  - Markdown ヘッダのレベル
  - RGB color
  - カッコの種類
  etc.
- 個別に有効化・無効化可能
][
#set text(16pt)

#align(center, [*設定例*])

```lua
local augend = require("dial.augend")
require("dial.config").augends:register_group{
  default = {
    -- 10進整数
    augend.integer.alias.decimal,
    -- "2023/06/30" のような日付
    augend.date.new {pattern = "%Y/%m/%d"},
    -- "2023年6月30日 (金)" のような日付
    augend.date.new {
      pattern = "%Y年%-m月%-d日 (%J)",
    },
    -- true/false
    augend.constant.new {
        elements = { "true", "false" },
    },
  }
}
```

]

= dial.nvim における増減ルール

- dial.nvim では増減ルールのことを *被加数 (augend)* と呼んでいる
  $
    #circle(
      radius: 75pt,
      // inset: (bottom: 0pt, top: 12pt),
      fill: colors.red.lighten(70%)
    )[
      #align(center + horizon)[
        123
      ]
      #place(center + bottom)[
        #text(..fonts.normal, size: 14pt, fill: colors.red)[*被加数* \ (*augend*)]
      ]
    ]
    +
    #circle(
      radius: 75pt,
      // inset: (bottom: 0pt, top: 12pt),
      fill: colors.blue.lighten(70%)
    )[
      #align(center + horizon)[
        20
      ]
      #place(center + bottom)[
        #text(..fonts.normal, size: 14pt, fill: colors.blue)[*加数* \ (*addend*)]
      ]
    ]
    = 143
  $

  #egblock[
    #egcode[ #text(fill: colors.red, [123]) ]
    #harrow(length: 100pt, upper_text: [#text(fill: colors.blue, [`20`])`<C-a>`])
    #egcode[ 143 ]
  ]

- 「日付」や「固定文字列」などは被加数の一種

#for layer in (1, 2) [
  = 被加数の例 (1)：日付・時刻

  - バッファ上の日付や時刻を好きな単位で増減する

    #egblock[
      #egcode[date: 2023/06/3#csr[0]]
      #harrow(upper_text: [`<C-a>`])
      #egcode[date: #cemph[2023/07/0#csr[1]]]

      #egcode[date: 2023/0#csr[6]/30]
      #harrow(upper_text: [`<C-a>`])
      #egcode[date: #cemph[2023/0#csr[7]]/31]

      #egcode[date: #csr[2]023/06/30]
      #harrow(upper_text: [`<C-a>`])
      #egcode[date: #cemph[202#csr[4]]/06/30]
    ]


  - 様々な形式の日付や時刻に対応（設定でパターンを指定可能）

    #if layer == 1 [
      #align(center)[
        #grid(
          columns: (1fr, 1fr, 0.75fr, 1.5fr),
          row-gutter: 20pt,
          `2023/06/30`,
          `2023-06-30`,
          `06/30`,
          `6月30日`,
          `06/30/2023`,
          `23/06/30`,
          `6/30`,
          `2023年6月30日(金)`,
          `30/06/2023`,
          `23/6/30`,
          `20:30`,
          `Fri 30 Jun 2023`,
        )
      ]
    ] else [
      #align(center)[
        #grid(
          columns: (1fr, 1fr, 0.75fr, 1.5fr),
          row-gutter: 20pt,
          `%Y/%m/%d`,
          `%Y-%m-%d`,
          `%m/%d`,
          `%-m月%-d日`,
          `%m/%d/%Y`,
          `%y/%m/%d`,
          `%-m/%-d`,
          `%Y年%-m月%-d日(%J)`,
          `%d/%m/%Y`,
          `%y/%-m/%-d`,
          `%M:%S`,
          `%a %d %b %Y`,
        )
      ]
    ]
]

= 被加数の例 (2)：固定文字列のトグル

- 複数の文字列を切り替える

  #egblock[
    #egcode[true]
    #harrow(upper_text: [`<C-a>`])
    #egcode[false]

    #egcode[&&]
    #harrow(upper_text: [`<C-a>`])
    #egcode[||]

    #egcode[a]
    #harrow(upper_text: [`<C-a>`])
    #egcode[b]
    #harrow(upper_text: [`<C-a>`])
    #egcode[c]
    #harrow(upper_text: [`<C-a>`])
    ...
    #harrow(upper_text: [`<C-a>`])
    #egcode[z]

    #egcode[var]
    #harrow(upper_text: [`<C-a>`])
    #egcode[let]
    #harrow(upper_text: [`<C-a>`])
    #egcode[const]

    ]

- 文字列パターンは自由に設定可能
- デフォルトでは単語として独立しているもののみ増減対象となる

  - "#emph[let]ter" が誤って "#emph[const]ter" となるのを防ぐ

= dial.nvim の特徴 (1)：標準にある機能のサポート

- *カウント*・*ドットリピート* をサポート
  - 例: 小数の増減ルールを有効にしている場合

    #egblock[
      #egcode[4.#csr[0]]
      #harrow(upper_text: [`8<C-a>`])
      #egcode[#cemph[4.#csr[8]]]
      #harrow(upper_text: [`.`])
      #egcode[#cemph[5.#csr[6]]]
      #harrow(upper_text: [`.`])
      #egcode[#cemph[6.#csr[4]]]
    ]

- ビジュアルモードでの増減、 `g<C-a>` / `g<C-x>` などをサポート
  - 例: 日付の増減ルールを用いて1週間単位での連番を作る

    #egblock[
      #egcode(inset: (x: 10pt))[
        2023/06/30

        #csr[
        2023/06/30

        2023/06/30

        2023/06/30
        ]
      ]
      #harrow(length: 100pt, upper_text: [`7g<C-a>`])
      #egcode(inset: (x: 10pt))[
        2023/06/30

        #cemph[
        #csr[2]023/07/07

        2023/07/14

        2023/07/21
        ]
      ]
    ]


= dial.nvim の特徴 (2)：賢いドットリピート

- 増減対象の種類を記憶して再現する

  #egblock[
    #set align(center + bottom)
    #grid(
      columns: 5,
      column-gutter: 5pt,
      row-gutter: 20pt,
    )[
      #egcode[(#csr[t]rue, 1, false)]
    ][
      #harrow(length: 50pt, upper_text: [`<C-a>`])
    ][
      #egcode[(#cemph[fals#csr[e]], 1, false)]
    ][
      #harrow(length: 30pt, upper_text: [`W`])
    ][
      #egcode[(false, #csr[1], false)]
    ][
    ][
    ][
    ][
      #set align(right)
      #harrow(length: 30pt, upper_text: [`.`])
    ][
      #egcode[(false, 1, #cemph[tru#csr[e]])]
    ]
  ]

- 日付の増減では、年月日のどれを増減したか記憶して再現する

  #egblock[
    #set align(center + bottom)
    #grid(
      columns: 3,
      column-gutter: 5pt,
      row-gutter: 20pt,
    )[
      #egcode[2023/0#csr[6]/29, 2023/07/12]
    ][
      #harrow(upper_text: [`<C-a>`])
    ][
      #egcode[#cemph[2023/0#csr[7]/29], 2023/07/12]
    ][
    ][
      #set align(right)
      #harrow(length: 50pt, upper_text: [`f,`])
    ][
      #egcode[2023/07/29#csr[,] 2023/07/12]
    ][
    ][
      #set align(right)
      #harrow(length: 50pt, upper_text: [`.`])
    ][
      #egcode[2023/07/31, #cemph[2023/0#csr[8]/14]]
    ]
  ]

= まとめ（宣伝）

- 標準の `<C-a>` / `<C-x>` だけでも今日は覚えて帰ってください
  - 標準の `<C-a>` / `<C-x>` だけでもぶっちゃけ便利

- `<C-a>` / `<C-x>` が好きになったら dial.nvim も検討してみてください

- Issue/PR 歓迎
  - Issue から生まれた機能もいくつかあります

#align(center)[
  #link("https://github.com/monaqa/dial.nvim")[#image("fig/dial.nvim.svg", width: 400pt)]

  *:qa!*
]


#section[おまけ: dial.nvim の仕組み][

#for layer in (1, 2, 3, 4, 5) [

  #let ccsr(cond, body) = {
    if cond {
      csr(body)
    } else {
      body
    }
  }

  #let ccemph(cond, body) = {
    if cond {
      cemph(body)
    } else {
      body
    }
  }

  = そもそも `<C-a>` / `<C-x>` の役割とはなにか

  - `<C-a>` / `<C-x>` の3つの仕事

    1. カーソル行から、増減対象の文字列を#emph[見つける]
    2. 増減対象の文字列にカーソルを#emph[移動する]
    3. 増減後の文字列へと増減対象を#emph[書き換える]

  - 具体例

    #egblock[

    #egcode[
      #ccsr(layer == 1 or layer == 2)[あ]る日の暮方の事である。
      #if layer <= 3 [
        #ccemph(layer == 2)[#ccsr(layer == 3)[1]]
      ] else [
        #csr[#cemph[2]]
      ]
      人の下人が、羅生門の下で雨やみを待っていた。
    ]

    #v(15pt)

    #(
      [],
      [
         #text(14pt, weight: 600)[カーソル行から、増減対象の文字列を#emph[見つける]]
      ],
      [
         #text(14pt, weight: 600)[増減対象の文字列にカーソルを#emph[移動する]]
      ],
      [
         #text(14pt, weight: 600)[増減後の文字列へと増減対象を#emph[書き換える]]
      ],
      [
         #text(14pt, weight: 600)[増減後の文字列へと増減対象を#emph[書き換える]]
      ],
    ).at(layer - 1)

    ]

  #if layer == 5 [
    #statement[これらの操作をうまく抽象化すると実装しやすそう]
  ]

]

= 増減ルールの定式化

// ---@alias findf fun(line: string, cursor?: integer) -> textrange?
// ---@alias addf fun(text: string, addend: integer, cursor?: integer) -> addresult?

- dial.nvim における被加数とは、以下の2つのメソッドを持つテーブル
  / `find`: カーソル行から増減対象を見つけるメソッド
  / `add`: 増減対象の文字列を実際に増減するメソッド

- 例: 整数の増減ルールを表す `augend`

  ```lua
augend:find("foo 123", 1)  -- "foo 123" という行の頭から整数を探す
--> {from = 5, to = 7}
augend:find("123 bar", 5)  -- "123 bar" という行の5文字目から整数を探す
--> nil

augend:add("123", 1)       -- "123" を整数として見て1を足す
--> {text = "124", cursor = 3}
augend:add("123", -30)     -- "123" を整数として見て30を引く
--> {text = "93", cursor = 2}
  ```

= dial.nvim における増減操作

#[
#show enum: set text(fill: colors.fg_weak)
0. 予め候補となる被加数（増減ルール）のリストを設定しておく
]

1. *select augend*: 設定で与えた全ての被加数の `find` メソッドを呼び出し、
  候補が見つかった被加数のうち最適な被加数 A を選ぶ
2. *text object*: A の `find` メソッドが返した範囲を選択する
3. *operator*: A の `add` メソッドを呼び出し、戻り値でテキストを置換する

#let mbox(color: colors.fg, body) = box(
  inset: (x: 3pt, y: 6pt),
  box(
    fill: color,
    outset: 2pt,
    inset: 5pt,
    text(
      ..fonts.normal,
      weight: 700,
    body)
  )
)

$
#[`<C-a>`]
=
overbrace(
  #mbox(color: colors.red.lighten(60%))[select augend]
  underbrace(
    #mbox(color: colors.blue.lighten(60%))[operator]
    #mbox(color: colors.bg_green.lighten(60%))[text object],
    #box(inset: (y: 6pt), text(..fonts.normal, size: 16pt, [ドットリピート時はここだけ実行]))
  ),
  #box(inset: (y: 6pt), text(..fonts.normal, size: 16pt, [`<C-a>` を押したときは全体を実行]))
)
$

#statement[
  operator + text object と見なせば、自然にドットリピート対応できる
  ]

= 最適な被加数をどのように選ぶか？
#egblock[
#egcodeblock[\#\# 2023年#csr[6]月30日 20:00 \@ 千駄ヶ谷]
]

= 最適な被加数をどのように選ぶか？

#let hl(body) = [#box(fill: colors.purple.lighten(70%),outset: (x: 0pt, y: 0.20em), strong[#body])]

#egblock[
#egcodeblock[\#\# 2023年#csr[6]月30日 20:00 \@ 千駄ヶ谷]

#egcode(inset: (x: 10pt))[\#\# 2023年#hl[6]月30日 20:00 \@ 千駄ヶ谷]

#egcode(inset: (x: 10pt))[\#\# #hl[2023年6月30日] 20:00 \@ 千駄ヶ谷]

#egcode(inset: (x: 10pt))[\#\# 20#hl[23年6月30日] 20:00 \@ 千駄ヶ谷]

#egcode(inset: (x: 10pt))[\#\# #hl[2023年6月]30日 20:00 \@ 千駄ヶ谷]

#egcode(inset: (x: 10pt))[\#\# 2023年#hl[6月30日] 20:00 \@ 千駄ヶ谷]

#egcode(inset: (x: 10pt))[\#\# 2023年6月30日 #hl[20:00] \@ 千駄ヶ谷]

#egcode(inset: (x: 10pt))[\#\# 2023年6#hl[月]30日 20:00 \@ 千駄ヶ谷]

#egcode(inset: (x: 10pt))[#hl[\#\#] 2023年6月30日 20:00 \@ 千駄ヶ谷]
]

#statement[短い1行の中にも様々な被加数が存在しうる。どれを選ぶべき？]

= 被加数の優先順位

#grid(columns: (300pt, auto), column-gutter: 20pt, row-gutter: 30pt)[][
#egcode(inset: (x: 10pt))[\#\# 2023年#csr[6]月30日 20:00 \@ 千駄ヶ谷]
][
#set align(horizon)
*カーソルに重なる被加数が最優先*
][
#egcode(inset: (x: 10pt))[\#\# #hl[2023年6月30日] 20:00 \@ 千駄ヶ谷]

#egcode(inset: (x: 10pt))[\#\# #hl[2023年6月]30日 20:00 \@ 千駄ヶ谷]

#egcode(inset: (x: 10pt))[\#\# 20#hl[23年6月30日] 20:00 \@ 千駄ヶ谷]

#egcode(inset: (x: 10pt))[\#\# 2023年#hl[6月30日] 20:00 \@ 千駄ヶ谷]

#egcode(inset: (x: 10pt))[\#\# 2023年#hl[6]月30日 20:00 \@ 千駄ヶ谷]
][
#set align(horizon)
カーソル後ろの被加数は次点
][
#egcode(inset: (x: 10pt))[\#\# 2023年6#hl[月]30日 20:00 \@ 千駄ヶ谷]

#egcode(inset: (x: 10pt))[\#\# 2023年6月30日 #hl[20:00] \@ 千駄ヶ谷]
][
#set align(horizon)
#text(fill: colors.fg_weak)[カーソル手前の被加数は優先度低]
][
#egcode(inset: (x: 10pt))[#hl[\#\#] 2023年6月30日 20:00 \@ 千駄ヶ谷]
]

= 被加数の優先順位

#grid(columns: (300pt, auto), column-gutter: 20pt, row-gutter: 30pt)[][
#egcode(inset: (x: 10pt))[\#\# 2023年#csr[6]月30日 20:00 \@ 千駄ヶ谷]
][
#set align(horizon)
さらに以下の規則で優先
- 開始位置が最も左のもの優先
- 開始位置が同じ場合、終了位置が最も右のもの優先
][
#egcode(inset: (x: 10pt))[\#\# #hl[2023年6月30日] 20:00 \@ 千駄ヶ谷]

#egcode(inset: (x: 10pt))[\#\# #hl[2023年6月]30日 20:00 \@ 千駄ヶ谷]

#egcode(inset: (x: 10pt))[\#\# 20#hl[23年6月30日] 20:00 \@ 千駄ヶ谷]

#egcode(inset: (x: 10pt))[\#\# 2023年#hl[6月30日] 20:00 \@ 千駄ヶ谷]

#egcode(inset: (x: 10pt))[\#\# 2023年#hl[6]月30日 20:00 \@ 千駄ヶ谷]
]

#statement[
  カーソル位置と増減範囲の相対的な位置関係のみで優先度を決めるため \
  どの被加数が選ばれるか直感的に判断しやすい。 \
  原則、#strong[カーソルに近く]、#strong[範囲の広い]被加数が優先的に選ばれる。
]


= まとめ

- dial.nvim における被加数とは「`find`, `add` メソッドを持つもの」
- dial.nvim が実際に行う操作は3種類
  - *select augend*: 最適な増減ルールの選択
  - *text object*: 増減対象の選択
  - *operator*: 増減の実行
- ドットリピートが使えるのは operator + text object による実装のおかげ
- 被加数の優先度はカーソルと増減範囲の相対位置関係のみから判断
  - 様々な種類のルールがあっても、それなりに高い精度で直感的な増減ルールを選択できる

]
