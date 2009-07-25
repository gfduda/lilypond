%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.12.3"

\header {
  lsrtags = "chords"

  texidoces = "
Para añadir indicaciones de línea divisoria dentro del contexto de
los nombres de acorde @code{ChordNames}, incluya el grabador
@code{Bar_engraver}.

"
  doctitlees = "Añadir barras de compás al contexto de nombres de acorde (ChordNames)"

  texidoc = "
To add bar line indications in the @code{ChordNames} context, add the
@code{Bar_engraver}.

"
  doctitle = "Adding bar lines to ChordNames context"
} % begin verbatim

\new ChordNames \with {
  \override BarLine #'bar-size = #4
  \consists "Bar_engraver"
}
\chordmode {
  f1:maj7 f:7 bes:7 
}


