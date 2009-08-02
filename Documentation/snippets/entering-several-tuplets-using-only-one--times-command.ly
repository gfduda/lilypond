%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.13.1"

\header {
  lsrtags = "rhythms"

%% Translation of GIT committish: b2d4318d6c53df8469dfa4da09b27c15a374d0ca
 doctitlees = "Escribir varios grupos especiales usando una sola instrucción \\times"
 texidoces = "
La propiedad @code{tupletSpannerDuration} establece cuánto debe durar
cada grupo de valoración especial contenido dentro del corchete que
aparece después de @code{\\times}.  Así, se pueden escribir muchos
tresillos seguidos dentro de una sola expresión @code{\\times},
ahorrando trabajo de teclado.

En el ejemplo se muestran dos tresillos, aunque se ha escrito
@code{\\times} una sola vez.


Para ver más inforamción sobre @code{make-moment}, véase
\"Administración del tiempo\".

"

%% Translation of GIT committish: d96023d8792c8af202c7cb8508010c0d3648899d
  texidocde = "
Die Eigenschaft @code{tupletSpannerDuration} bestimmt, wie lange jede
der N-tolen innerhalb der Klammern nach dem @code{\\times}-Befehl
dauert.  Auf diese Art können etwa viele Triolen nacheinander mit nur
einem @code{\\times}-Befehl geschrieben werden.

Im Beispiel sind zwei Triolen zu sehen, obwohl @code{\\times} nur
einmal geschrieben wurde.

Mehr Information über @code{make-moment} gibt es in \"Verwaltung der Zeiteinheiten\". 

"
  doctitlede = "Mehrere Triolen notieren, aber nur einmal \\times benutzen"


%% Translation of GIT committish: e71f19ad847d3e94ac89750f34de8b6bb28611df
  texidocfr = "
La propriété @code{tupletSpannerDuration} spécifie la longueur voulue de
chaque crochet.  Avec elle, vous pouvez faire plusieurs nolets en ne
tapant @code{\\times} qu'une fois, ce qui évite une longue saisie.  

Dans l'exemple suivant, deux triolets sont imprimés avec une seule fonction
@code{\\times}.

Pour plus d'information sur @code{make-moment}, voir @ref{Time administration}.

"
  doctitlefr = "Plusieurs triolets avec une seule commande \\times"

  texidoc = "
The property @code{tupletSpannerDuration} sets how long each of the
tuplets contained within the brackets after @code{\\times} should last.
Many consecutive tuplets can then be placed within a single
@code{\\times} expression, thus saving typing.

In the example, two triplets are shown, while @code{\\times} was
entered only once.


For more information about @code{make-moment}, see \"Time
administration\". 

"
  doctitle = "Entering several tuplets using only one \\times command"
} % begin verbatim

\relative c' {
  \time 2/4
  \set tupletSpannerDuration = #(ly:make-moment 1 4)
  \times 2/3 { c8 c c c c c }
}
