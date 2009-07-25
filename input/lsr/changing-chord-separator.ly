%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.12.3"

\header {
  lsrtags = "chords"

  texidoces = "
Se puede establecer el separador entre las distintas partes del
nombre de un acorde para que sea cualquier elemento de marcado.

"
  doctitlees = "Modificación del separador de acordes"

  texidoc = "
The separator between different parts of a chord name can be set to any
markup.

"
  doctitle = "Changing chord separator"
} % begin verbatim

\chords {
  c:7sus4
  \set chordNameSeparator
    = \markup { \typewriter | }
  c:7sus4
}

