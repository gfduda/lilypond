%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.12.3"

\header {
  lsrtags = "rhythms"

  texidoces = "
Las reglas de final de barra especificadas en el contexto
@code{Score} se aplican a todos los pentagramas, pero se pueden
modificar tanto en los niveles de @code{Staff} como de
@code{Voice}:

"
  doctitlees = "Finales de barra en el contexto Score"

  texidoc = "
Beam-ending rules specified in the @code{Score} context apply to all
staves, but can be modified at both @code{Staff} and @code{Voice}
levels: 

"
  doctitle = "Beam endings in Score context"
} % begin verbatim

\relative c'' {
  \time 5/4
  % Set default beaming for all staves
  #(score-override-auto-beam-setting '(end * * 5 4) 3 8)
  #(score-override-auto-beam-setting '(end * * 5 4) 7 8)
  <<
    \new Staff {
      c8 c c c c c c c c c
    }
    \new Staff {
      % Modify beaming for just this staff
      #(override-auto-beam-setting '(end * * 5 4) 6 8 'Staff)
      #(revert-auto-beam-setting '(end * * 5 4) 7 8 'Staff)
      c8 c c c c c c c c c
    }
    \new Staff {
      % Inherit beaming from Score context
      <<
        {
          \voiceOne
          c8 c c c c c c c c c
        }
        % Modify beaming for this voice only
        \new Voice {
          \voiceTwo
          #(override-auto-beam-setting '(end * * 5 4) 6 8)
          #(revert-auto-beam-setting '(end * * 5 4) 7 8)
          a8 a a a a a a a a a
        }
      >>
    }
  >>
}

