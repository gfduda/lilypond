% DO NOT EDIT this file manually; it is automatically
% generated from Documentation/snippets/new
% Make any changes in Documentation/snippets/new/
% and then run scripts/auxiliar/makelsr.py
%
% This file is in the public domain.
%% Note: this file works from version 2.14.0
\version "2.14.0"

\header {
%% Translation of GIT committish: 8b93de6ce951b7b14bc7818f31019524295b990f
  texidoces = "

Los deslizamientos se pueden componer tipográficamente tanto en los
contextos de @code{Staff} como en los de @code{TabStaff}:

"

  doctitlees = "Deslizamientos en tablatura"

%% Translation of GIT committish: f86f00c1a8de0f034ba48506de2801c074bd5422
  texidocde = "
Gleiten kann sowohl in normalem Notensystem als auch in Tabulaturen notiert werden:
"
  doctitlede = "Gleiten (Glissando) in Tabulatur"

%% Translation of GIT committish: 40bf2b38d674c43f38058494692d1a0993fad0bd
  texidocfr = "
Un glissando s'indique dans un @code{TabStaff} tout comme dans un
@code{Staff}.

"

  doctitlefr = "Glissando et tablature"


  lsrtags = "fretted-strings"
  texidoc = "
Slides can be typeset in both @code{Staff} and @code{TabStaff} contexts:
"
  doctitle = "Slides in tablature"
} % begin verbatim


slides = {
  c'8\3(\glissando d'8\3)
  c'8\3\glissando d'8\3
  \hideNote
  \grace { g16\3\glissando }
  c'4\3
  \afterGrace d'4\3\glissando {
  \stemDown \hideNote
  g16\3 }
}

\score {
  <<
    \new Staff { \clef "treble_8" \slides }
    \new TabStaff { \slides }
  >>
  \layout {
    \context {
      \Score
      \override Glissando #'minimum-length = #4
      \override Glissando #'springs-and-rods =
                          #ly:spanner::set-spacing-rods
      \override Glissando #'thickness = #2
    }
  }
}
