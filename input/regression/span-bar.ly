\version "2.1.23"
\header {
texidoc = "Span bars draw only in between staff bar lines, so setting those to transparent shows bar lines between systems only.
"
}

\score {
 \notes \relative c' \new StaffGroup <<
 \new Staff { a1 a1 a1}
  \new Lyrics \lyrics <<
   { bla1 die bla }
   { foo bar foo }
  >>
  \new Staff { f1 f1 f1}
 >>
 \paper {
  \translator {
   \StaffContext
   \override BarLine #'transparent = ##t
  }
  raggedright =##t 
 }
}

