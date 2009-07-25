%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.12.3"

\header {
  lsrtags = "expressive-marks"

  texidoces = "
Si los reguladores son demasiado cortos, se pueden alargar
modificando la propiedad @code{minimum-length} del objeto
@code{Hairpin}.

"
  doctitlees = "Ajustar la longitud mínima de los reguladores"
  
%% Translation of GIT committish :<6ce7f350682dfa99af97929be1dec6b9f1cbc01a>
texidocde = "
Wenn Crescendo-Klammern zu kurz sind, können sie verlängert werden, indem
die @code{minimum-length}-Eigenschaft des @code{Hairpin}-Objektes
verändert wird. 

"
  doctitlede = "Die Mindestlänge von Crescendo-Klammern bestimmen"

  texidoc = "
If hairpins are too short, they can be lengthened by modifying the
@code{minimum-length} property of the @code{Hairpin} object. 

"
  doctitle = "Setting the minimum length of hairpins"
} % begin verbatim

\relative c'' {
  c4\< c\! d\> e\!
  \override Hairpin #'minimum-length = #5
  << f1 { s4 s\< s\> s\! } >>
}

