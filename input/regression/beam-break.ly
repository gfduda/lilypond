
\header {
    texidoc = "Beams can be printed across line breaks if forced.
"

}
\version "2.1.22"
    \paper { raggedright= ##t }

\score { \notes \relative c''  {
    \set Score.forbidBeamBreak = ##f
   \time 3/16 c16-[ d e \break f-] 
}}
