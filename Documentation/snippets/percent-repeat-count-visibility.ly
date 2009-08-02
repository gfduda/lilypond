%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.13.1"

\header {
  lsrtags = "repeats, tweaks-and-overrides"

%% Translation of GIT committish: b2d4318d6c53df8469dfa4da09b27c15a374d0ca
  texidoces = "
Se pueden mostrar los contadores de las repeticiones del tipo
porcentaje a intervalos regulares mediante el establecimiento de
la propiedad de contexto @code{repeatCountVisibility}.

"
  doctitlees = "Visibilidad del contador de repeticiones de tipo porcentaje"

%% Translation of GIT committish: d96023d8792c8af202c7cb8508010c0d3648899d
  texidocde = "
Prozentwiederholungszähler können in regelmäßigen Intervallen angezeigt
werden, indem man die Eigenschaft @code{repeatCountVisibility} beeinflusst.
"
  doctitlede = "Sichtbarkeit von Prozent-Wiederholungen"

  texidoc = "
Percent repeat counters can be shown at regular intervals by setting
the context property @code{repeatCountVisibility}.

"
  doctitle = "Percent repeat count visibility"
} % begin verbatim

\relative c'' {
  \set countPercentRepeats = ##t
  \set repeatCountVisibility = #(every-nth-repeat-count-visible 5)
  \repeat percent 10 { c1 } \break
  \set repeatCountVisibility = #(every-nth-repeat-count-visible 2)
  \repeat percent 6 { c1 d1 }
}