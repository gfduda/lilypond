;;;; tex.scm -- implement Scheme output routines for TeX
;;;;
;;;;  source file of the GNU LilyPond music typesetter
;;;; 
;;;; (c)  1998--2004 Jan Nieuwenhuizen <janneke@gnu.org>
;;;;                 Han-Wen Nienhuys <hanwen@cs.uu.nl>


;; (debug-enable 'backtrace)

;; The public interface is tight.
;; It has to be, because user-code is evalled with this module.

;; ***It should also be clean, well defined, documented and reviewed***

;; To be reasonably safe, you probably do not want to use the TeX
;; backend anyway, but rather the PostScript backend.  You may want
;; to run gs in a uml sandbox too.


(define-module (scm output-tex)
  #:re-export (quote)

  ;; JUNK this -- see lily.scm: ly:all-output-backend-commands
  #:export (unknown
	    blank
	    dot
	    white-dot
	    beam
	    bracket
	    dashed-slur
	    named-glyph
	    dashed-line
	    zigzag-line
	    ez-ball
	    comment
	    repeat-slash
	    placebox
	    bezier-sandwich
	    horizontal-line
	    filledbox
	    round-filled-box
	    text
	    white-text
	    polygon
	    draw-line
	    no-origin
	    grob-cause))

(use-modules (ice-9 regex)
	     (ice-9 string-fun)
	     (ice-9 format)
	     (guile)
	     (srfi srfi-13)
	     (scm framework-tex)
	     (lily))



;;;;;;;;
;;;;;;;; DOCUMENT ME!
;;;;;;;;


(define (char font i)
  (string-append "\\" (tex-font-command font)
		 "\\char" (ly:inexact->string i 10) " "))

(define (unknown) 
  "%\n\\unknown\n")



(define (blank)
  "")

(define (dot x y radius)
  (embedded-ps (list 'dot x y radius)))


(define (embedded-ps string)
  (embedded-ps (list 'embedded-ps string)))

(define (white-dot x y radius)
  (embedded-ps (list 'white-dot x y radius)))

(define (beam width slope thick blot)
  (embedded-ps (list 'beam  width slope thick blot)))

(define (bracket arch_angle arch_width arch_height height arch_thick thick)
  (embedded-ps (list 'bracket  arch_angle arch_width arch_height height arch_thick thick)))

(define (dashed-slur thick on off lst)
  (embedded-ps (list 'dashed-slur thick on off `(quote ,lst))))

(define (named-glyph font name)
  (let* ((info (ly:otf-font-glyph-info font name))
	 (subfont (assoc-get 'subfont info))
	 (subidx  (assoc-get 'subfont-index info)))
    
    ;;(stderr "INFO: ~S\n" info)
    ;;(stderr "FONT: ~S\n" font)
    (if (and subfont subidx)
	(string-append "\\" (tex-font-command-raw
			     subfont
			     (ly:font-magnification font))
		       "\\char" (number->string subidx))

	(begin
	  (ly:warn "Can't find ~a in ~a" name font)
	  ""))))

(define (dashed-line thick on off dx dy)
  (embedded-ps (list 'dashed-line  thick on off dx dy)))

(define (zigzag-line centre? zzw zzh thick dx dy)
  (embedded-ps (list 'zigzag-line centre? zzw zzh thick dx dy)))

(define (ez-ball c lst b)
  (embedded-ps (list 'ez-ball c lst b)))

(define (embedded-ps expr)
  (let ((ps-string
	 (with-output-to-string
	   (lambda () (ps-output-expression expr (current-output-port))))))
    (string-append "\\embeddedps{" ps-string "}")))

(define (repeat-slash w a t)
  (embedded-ps (list 'repeat-slash  w a t)))

(define (number->dim x)
  (string-append
   ;;ugh ly:* in backend needs compatibility func for standalone output
   (ly:number->string x) " \\outputscale "))

(define (placebox x y s) 
  (string-append
   "\\lyitem{" (ly:number->string x) "}{" (ly:number->string y) "}{" s "}%\n"))

(define (bezier-sandwich lst thick)
  (embedded-ps (list 'bezier-sandwich `(quote ,lst) thick)))

;; WTF is this in every backend?
(define (horizontal-line x1 x2 th)
  (filledbox (- x1) (- x2 x1) (* .5 th) (* .5 th)))

(define (filledbox breapth width depth height)
  (if (and #f (defined? 'ps-testing))
      (embedded-ps
       (string-append (ly:numbers->string (list breapth width depth height))
		      " draw_box" ))
      (string-append "\\lyvrule{"
		     (ly:number->string (- breapth)) "}{"
		     (ly:number->string (+ breapth width)) "}{"
		     (ly:number->string depth) "}{"
		     (ly:number->string height) "}")))

(define (round-filled-box x y width height blotdiam)
  (embedded-ps (list 'round-filled-box  x y width height blotdiam)))

(define (text font s)
  (format
   "\\hbox{\\~a{}~a}" (tex-font-command font)
   (sanitize-tex-string s)))

(define (white-text scale s)
  (embedded-ps (list 'white-text scale s)))

(define (polygon points blotdiameter)
  (embedded-ps (list 'polygon `(quote ,points) blotdiameter)))

(define (draw-line thick fx fy tx ty)
  (embedded-ps (list 'draw-line thick fx fy tx ty)))

;; no-origin not yet supported by Xdvi
(define (no-origin) "")

(define (grob-cause offset grob)
  (if (procedure? point-and-click)
      (let* ((cause (ly:grob-property grob 'cause))
	     (music-origin (if (ly:music? cause)
			       (ly:music-property cause 'origin)))
	     (location (if (ly:input-location? music-origin)
			   (ly:input-file-line-column music-origin))))
	(if (pair? location)
	     ;;; \\string ? 
	    (string-append "\\special{src:"
			   (apply point-and-click location) "}")
	    ""))
      ""))
