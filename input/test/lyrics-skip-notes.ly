
\header
{
texidoc ="

By inserting @code{\\skip} statements into lyric lines, one can put less lyric syllables to a melody. 

"
}


% shorthand for Skip Lyric
sl = \notes { \skip 4 }

\version "2.1.26"
\score {
  <<
  \context Voice = "A"  \notes  {c4 c c c}
  \lyricsto "A" \context Lyrics=A \lyrics { foo __ \sl \sl bar }
  \lyricsto "A" \context Lyrics=B \lyrics { foo -- \sl baz bar }
  \lyricsto "A" \context Lyrics=C \lyrics { foo -- baz -- baaz bar }
  >>
}
