% DO NOT EDIT this file manually; it is automatically
% generated from Documentation/snippets/new
% Make any changes in Documentation/snippets/new/
% and then run scripts/auxiliar/makelsr.py
%
% This file is in the public domain.
%% Note: this file works from version 2.17.6
\version "2.17.6"

\header {
  lsrtags = "rhythms, vocal-music, ancient-notation, contexts-and-engravers, specific-notation"

  texidoc = "
This form of notation is used for the chant of the Psalms, where verses
aren't always the same length.

"
  doctitle = "Chant or psalms notation"
} % begin verbatim


stemOn = {
  \revert Staff.Stem.transparent
  \revert Staff.Flag.transparent
}

stemOff = {
  \override Staff.Stem.transparent = ##t
  \override Staff.Flag.transparent = ##t
}

\score {
  \new Staff \with { \remove "Time_signature_engraver" }
  {
    \key g \minor
    \cadenzaOn
    \stemOff a'\breve bes'4 g'4
    \stemOn a'2 \bar "||"
    \stemOff a'\breve g'4 a'4
    \stemOn f'2 \bar "||"
    \stemOff a'\breve^\markup { \italic flexe }
    \stemOn g'2 \bar "||"
  }
}
