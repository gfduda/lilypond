%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.12.3"

\header {
  lsrtags = "tweaks-and-overrides"

  texidoc = "
The @code{\\applyOutput} command allows the tuning of any layout
object, in any context. It requires a Scheme function with three
arguments.

"
  doctitle = "Changing properties for individual grobs"
} % begin verbatim

#(define (mc-squared grob grob-origin context)
  (let ((sp (ly:grob-property grob 'staff-position)))
    (if (grob::has-interface grob 'note-head-interface)
      (begin
        (ly:grob-set-property! grob 'stencil
          (grob-interpret-markup grob
            (make-lower-markup 0.5
              (case sp
                ((-5) "m")
                ((-3) "c ")
                ((-2) (make-smaller-markup (make-bold-markup "2")))
                (else "bla")))))))))

\relative c' {
  <d f g b>2
  \applyOutput #'Voice #mc-squared
  <d f g b>2
}
