%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.12.3"

\header {
  lsrtags = "expressive-marks"

  texidoces = "
El glifo de la marca de respiración se puede ajustar
sobreescribiendo la propiedad de texto del objeto de presentación
@code{BreathingSign}, con cualquier otro texto de marcado.

"
  doctitlees = "Cambiar el símbolo de la marca de respiración"
  
%% Translation of GIT committish :<6ce7f350682dfa99af97929be1dec6b9f1cbc01a>
  texidocde = "
Das Schriftzeichen für das Atemzeichen kann verändert werden, indem
die Text-Eigenschaft des @code{BreathingSign}-Layoutobjekts mit einer
beliebigen Textbeschriftung definiert wird.

"
  doctitlede = "Das Atemzeichen-Symbol verändern"

  texidoc = "
The glyph of the breath mark can be tuned by overriding the text
property of the @code{BreathingSign} layout object with any markup
text. 

"
  doctitle = "Changing the breath mark symbol"
} % begin verbatim

\relative c'' {
  c2
  \override BreathingSign #'text = \markup { \musicglyph #"scripts.rvarcomma" }
  \breathe
  d2
}
