% Do not edit this file; it is automatically
% generated from Documentation/snippets/new
% This file is in the public domain.
%% Note: this file works from version 2.13.21
\version "2.13.21"

\header {
%% Translation of GIT committish: 22d889f4d27469864c31db81445e9de49774ae23

  texidoces = "
Esta plantilla crea una partitura que comienza con una estrofa para
solista y continúa con un estribillo a dos voces.  también muestra el
uso de silencios de separación dentro de la variable @code{\global}
para definir cambios de compás (y otros elementos que son comunes a
todas las partes) a lo largo de toda la partitura.

"

  doctitlees = "Estrofa para solista y estribillo a dos voces"

  lsrtags = "vocal-music, contexts-and-engravers, template"
  texidoc = "
This template creates a score which starts with a solo verse and
continues into a refrain for two voices.  It also demonstrates the
use of spacer rests within the @code{\global} variable to define
meter changes (and other elements common to all parts) throughout
the entire score.
"
  doctitle = "Solo verse and two-part refrain"
} % begin verbatim


global = {
  \key g \major

  % verse
  \time 3/4
  s2.*2
  \break

  % refrain
  \time 2/4
  s2*2
  \bar "|."
}

SoloNotes = \relative g' {
  \clef "treble"

  % verse
  g4 g g |
  b4 b b |

  % refrain
  R2*2 |
}

SoloLyrics = \lyricmode {
  One two three |
  four five six |
}

SopranoNotes = \relative c'' {
  \clef "treble"

  % verse
  R2.*2 |

  % refrain
  c4 c |
  g4 g |
}

SopranoLyrics = \lyricmode {
  la la |
  la la |
}

BassNotes = \relative c {
  \clef "bass"

  % verse
  R2.*2 |

  % refrain
  c4 e |
  d4 d |
}

BassLyrics = \lyricmode {
  dum dum |
  dum dum |
}

\score {
  <<
    \new Voice = "SoloVoice" << \global \SoloNotes >>
    \new Lyrics \lyricsto "SoloVoice" \SoloLyrics

    \new ChoirStaff <<
      \new Voice = "SopranoVoice" << \global \SopranoNotes >>
      \new Lyrics \lyricsto "SopranoVoice" \SopranoLyrics

      \new Voice = "BassVoice" << \global \BassNotes >>
      \new Lyrics \lyricsto "BassVoice" \BassLyrics
    >>
  >>
  \layout {
    ragged-right = ##t
    \context { \Staff
      % these lines prevent empty staves from being printed
      \RemoveEmptyStaves
      \override VerticalAxisGroup #'remove-first = ##t
    }
  }
}
