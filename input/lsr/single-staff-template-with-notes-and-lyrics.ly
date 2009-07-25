%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.12.3"

\header {
  lsrtags = "vocal-music, template"

  texidoces = "
Esta pequeña plantilla muestra una melodía sencilla con letra. Córtela
y péguela, escriba las notas y luego la letra. Este ejemplo desactiva
el barrado automático, que es lo más frecuente en las partes vocales
antiguas. Para usar el barrado automático modifique o marque como un
comentario la línea correspondiente.

"
  doctitlees = "Plantilla de pentagrama único don notas y letra"
  
  texidocde = "
Das nächste Beispiel zeigt eine einfache Melodie mit Text. Kopieren 
Sie es in Ihre Datei, fügen Sie Noten und Text hinzu und übersetzen 
Sie es mit LilyPond. In dem Beispiel wird die automatische 
Balkenverbindung ausgeschaltet (mit dem Befehl @code{\autoBeamOff}), 
wie es für Vokalmusik üblich ist. 
Wenn Sie die Balken wieder einschalten wollen, müssen Sie die 
entsprechende Zeile entweder ändern oder auskommentieren.
"

  texidoc = "
This small template demonstrates a simple melody with lyrics. Cut and
paste, add notes, then words for the lyrics. This example turns off
automatic beaming, which is common for vocal parts. To use automatic
beaming, change or comment out the relevant line.

"
  doctitle = "Single staff template with notes and lyrics"
} % begin verbatim

melody = \relative c' {
  \clef treble
  \key c \major
  \time 4/4
  
  a4 b c d
}

text = \lyricmode {
  Aaa Bee Cee Dee
}

\score{
  <<
    \new Voice = "one" {
      \autoBeamOff
      \melody
    }
    \new Lyrics \lyricsto "one" \text
  >>
  \layout { }
  \midi { }
}

