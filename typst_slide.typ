#let page_size = (width: 254mm, height: 142.9mm)
#let page_margin = 16pt

#let state_section_name = state("section_name", none)
#let state_inner_section = state("inner_section", false)

#let colors = (
  bg: rgb("#e8e9ec"),
  bg_code: rgb("#dcdfe7"),
  fg: rgb("#33374c"),
  fg_weak: rgb("#6b7089"),
  red: rgb("#cc517a"),
  blue: rgb("#2d539e"),
  skyblue: rgb("#3f83a6"),
  purple: rgb("#7759b4"),
  bg_green: rgb("#668e3d"),
)

#let fonts = (
  normal: (
    size: 20pt,
    font: ("IBM Plex Sans JP", "Hack Nerd Font"),
    fill: colors.fg,
    weight: 400,
    lang: "ja",
  ),
  raw: (
    font: ("Hack Nerd Font", "IBM Plex Sans JP"),
  ),
)

// レイアウトの設定はここにまとめる
#let layout = {

  // states
  let state_first_frame_in_section = state("first_frame_in_section", false)

  let title_slide(
    title,
    author: none,
    date: none,
  ) = page(
    background: place(left + top, rect(
      fill: rgb("#1e2132"),
      height: 100%,
      width: 100%
    )),
    footer: none,
    {
      counter(page).update(0)
      set align(center + horizon)
      set text(fill: rgb("#e8e9ec"))

      place(
        center + top,
        dy: -page_margin,
        rect(
          fill: rgb("#33374c"),
          inset: 20pt,
          height: page_size.height / 2,
          width: page_size.width,
          {
            set text(32pt, weight: 600)
            set par(leading: 1em)
            set align(center + bottom)
            block(title)
          }
        ),
      )

      place(
        center + bottom,
        rect(
          inset: 20pt,
          stroke: none,
          height: 50%,
          width: 100%,
          {
            set text(24pt)
            set align(center + top)

            block(author)

            set text(20pt)
            block(date)
          }
        ),
      )
    }
  )

  let section_title(it) = page(
    footer: none,
    {
      counter(page).update(c => c - 1)
      set text(32pt, weight: 600)
      set align(horizon + center)

      place(
        center + top,
        dy: -page_margin,
        rect(
          stroke: none,
          inset: 20pt,
          height: page_size.height * 55%,
          width: page_size.width,
          {
            set align(bottom)
            it
          }
        ),
      )

      place(
        center + bottom,
        dy: page_margin,
        rect(
          fill: rgb("#6b7089"),
          inset: 16pt,
          height: page_size.height * 45%,
          width: page_size.width,
          {
            set align(top)
            set text(fill: rgb("#636983"))
            scale(y: -80%, it)
          }
        ),
      )

      state_first_frame_in_section.update(true)
    })

  let frame_title(it) = {
    locate(loc => {
    if not state_first_frame_in_section.at(loc) {
      pagebreak(weak: true)
    }
    if not state_inner_section.at(loc) {
      state_section_name.update(none)
    }
    })
    set text(28pt, weight: 300)
    set par(leading: 0.4em)
    // spacing の設定
    set block(below: 16pt)
    set align(center)
    block(
      height: 28pt,
      width: page_size.width - 20pt,
      stroke: (bottom: 1pt + rgb("#6b7089")),
      inset: (bottom: 8pt),
      {
        set align(left + bottom)
        it
      }
    )
    state_first_frame_in_section.update(false)
  }

  let heading_inner_frame(it) = {
    set text(20pt, weight: 600)
    block(it, below: 1.1em)
  }

  let strong(it) = {
    text(it.body, weight: 600)
  }

  let emph(it) = {
    text(colors.purple, it.body)
  }

  let raw_inline(it) = {
    // set text(1.2em, font: ("M+ 1m", "Hack Nerd Font", "IBM Plex Sans JP"))
    set text(1.10em, font: ("Hack Nerd Font", "IBM Plex Sans JP"))
    box(
      fill: rgb("#dcdfe7"),
      inset: (x: 0.15em),
      outset: (x: 0pt, y: 0.30em),
      radius: 2pt,
      it
    )
  }

  // let raw_block(it) = {
  //   // set text(16pt, font: ("M+ 1m", "Hack Nerd Font", "IBM Plex Sans JP"))
  //   set text(14pt, font: ("Hack Nerd Font", "IBM Plex Sans JP"))
  //   set par(leading: 0.5em)
  //   block(
  //     width: 100%,
  //     fill: colors.bg_code, inset: (x: 4pt, top: 8pt, bottom: 8pt), radius: 2pt, it
  //   )
  // }

  // let raw_named(it) = {
  //   set text(16pt, font: ("M+ 1m", "Hack Nerd Font", "IBM Plex Sans JP"))
  //   set par(leading: 0.5em)
  //   block(
  //     width: 100%,
  //     fill: colors.bg_code, inset: (x: 4pt, top: 8pt, bottom: 8pt), radius: 2pt, it
  //   )
  // }

  let link(it) = {
    set text(fill: colors.blue)
    it
  }

  let background_fn(loc) = {
    place(left + top, rect(
          fill: colors.bg,
          height: 100%,
          width: 100%
          ))
  }

  (
    background_fn: background_fn,
    title_slide: title_slide,
    section_title: section_title,
    frame_title: frame_title,
    strong: strong,
    emph: emph,
    link: link,
    raw_inline: raw_inline,
    // raw_block: raw_block,
    heading_inner_frame: heading_inner_frame,
  )

}

#let section(title, child, ) = {
  layout.at("section_title")(title)
  state_inner_section.update(true)
  state_section_name.update(title)

  child

  state_inner_section.update(false)
}

// Slide 全体を作る関数。 show slide.with() での利用を想定。
#let slide(
  body,
  title: "Slide title",
  author: none,
  date: none,
  show_title_slide: true,
  confidential_mark: none,
) = {
  if type(title) == "string" {
    // metadata 設定
    set document(title: title)
  }


  // page 設定のうち、基本的に全ページ共通のもの。

  let foreground = {
    if confidential_mark != none {
      place(
        right + top,
        dx: -10pt,
        dy: 10pt,
        rect(
          height: 20pt,
          width: 100pt,
          stroke: 2pt + red,
          {
            set align(horizon + center)
            set text(16pt, fill: red, weight: 600)
            confidential_mark
          }
        )
      )
    } else {
    none
    }
  }

  set page(
    margin: page_margin,
    width : page_size.width,
    height : page_size.height,
    foreground: foreground,
    background: locate(layout.at("background_fn")),
    footer: [
      #place(
        right + bottom,
        dy: -10pt,
        [
          #set text(12pt, fill: colors.fg_weak, weight: 400)
          #counter(page).display("1/1", both: true)
        ]
      )
      #place(
        center + bottom,
        dy: -10pt,
        [
          #set text(12pt, fill: colors.fg_weak, weight: 400)
          #locate(loc => {
            let section_name = state_section_name.at(loc)
            section_name
          })
        ]
        )
    ],
  )

  // 全体のテキストに関する設定
  set text(..fonts.normal)

  set par(
    leading: 0.7em
  )

  set block(
    spacing: 0.9em
  )

  show raw.where(block: false): layout.raw_inline
  // show raw.where(block: true): set text(16pt, font: ("Hack Nerd Font", "IBM Plex Sans JP"))
  show raw.where(block: true): set text(font: ("Hack Nerd Font", "IBM Plex Sans JP"))
  show raw.where(block: true): set par(leading: 0.5em)
  show raw.where(block: true): block.with(
      width: 100%,
      fill: colors.bg_code, inset: (x: 4pt, top: 8pt, bottom: 8pt), radius: 2pt
  )

  // show heading.where(level: 1): layout.section_title
  show heading.where(level: 1): layout.frame_title
  show heading.where(level: 2): layout.heading_inner_frame
  show strong: layout.strong
  show emph: layout.emph
  show link: layout.link

  set list(
    marker: (
      scale(x: 50%, y: 50%, text(fill: colors.skyblue, [◆])),
      scale(x: 60%, y: 60%, text(fill: colors.skyblue, [▶#h(0.2em)])),
      scale(x: 40%, y: 40%, text(fill: colors.skyblue, [●])),
    ),
    spacing: 1.0em,
    body-indent: 0.1em,
  )

  if show_title_slide {
    layout.at("title_slide")(title, author: author, date: date)
  }

  body
}
