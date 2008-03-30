%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.11.38"

\header {
  lsrtags = "rhythms, percussion"
 texidoc = "
In the following snippet, two parts have a completely different time
signature, yet remain synchronized. The barlines can't be printed at
the @code{Score} level anymore, so you have to remove the
@code{Barline_engraver} and put it in the @code{Staff} context. 
" }
% begin verbatim
% Thanks to Adam James Wilson for this snippet

\paper {
  indent = #0
  ragged-right = ##t
}

global = { \time 3/4 { s2.*3 } \bar "" \break { s2.*3 } }

\layout {
  \context {
    \Score
    \remove "Timing_translator"
    \remove "Time_signature_engraver"
    \remove "Default_bar_line_engraver"
    \override SpacingSpanner #'uniform-stretching = ##t
    \override SpacingSpanner #'strict-note-spacing = ##t
    proportionalNotationDuration = #(ly:make-moment 1 64)
  }
  \context {
    \Staff
    \consists "Timing_translator"
    \consists "Default_bar_line_engraver"
    \consists "Time_signature_engraver"
  }
  \context {
    \Voice
    \remove "Forbid_line_break_engraver"
    tupletFullLength = ##t
  }
}

Bassklarinette = \new Staff <<
  \global {
    \bar "|"
    \clef treble
    \time 3/8
    d''4.
    
    \bar "|"
    \time 3/4
    r8 des''2( c''8)
    
    \bar "|"
    \time 7/8
    r4. ees''2 ~
    
    \bar "|"
    \time 2/4
    \tupletUp
    \times 2/3 { ees''4 r4 d''4 ~ }
    
    \bar "|"
    \time 3/8
    \tupletUp
    \times 3/4 { d''4 r4 }
    
    \bar "|"
    \time 2/4
    e''2
    
    \bar "|"
    \time 3/8
    es''4.
    
    \bar "|"
    \time 3/4
    r8 d''2 r8
    \bar "|"
  }
>>

Perkussion = \new StaffGroup <<
  \new Staff <<
    \global {
      \bar "|"
      \clef percussion
      \time 3/4
      r4 c'2 ~
      
      \bar "|"
      c'2.
      
      \bar "|"
      R2.
      
      \bar "|"
      r2 g'4 ~
      
      \bar "|"
      g'2. ~
      
      \bar "|"
      g'2.
    }
  >>
  \new Staff <<
    \global {
      \bar "|"
      \clef percussion
      \time 3/4
      R2.
      
      \bar "|"
      g'2. ~
      
      \bar "|"
      g'2.
      
      \bar "|"
      r4 g'2 ~
      
      \bar "|"
      g'2 r4
      
      \bar "|"
      g'2.
    }
  >>
>>

\score {
  <<  \Bassklarinette \Perkussion >>
}
