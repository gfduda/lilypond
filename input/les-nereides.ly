%{
cpp -P -traditional -o l.ly les-nereides.ly
cpp -P -traditional -o l-fake.ly  -DFAKE_GRACE les-nereides.ly
%}

\header{
    composer =   "ARTHUR GRAY";
    title =      "LES N\\'ER\\'EIDES";
    subtitle =   "THE NEREIDS";
    enteredby =  "JCN";
    %piece =      "Allegretto scherzando";
    copyright =  "public domain";
    description = "Natiest piece of competition at http://www.orphee.com/comparison/study.html, see http://www.orphee.com/comparison/gray.pdf";
    comment =     "LilyPond (1.3.93) can't really do this yet, I guess";
}


%% cpp: don't start on first column
 #(define (grace-beam-space-function multiplicity)
         (* (if (<= multiplicity 3) 0.816 0.844) 0.8))

%% cpp: don't start on first column
%% hmm, why doesn't this work?
 #(define (make-text-checker text)
  (lambda (elt)
    (and (not (eq? #f (memq 'text-item-interface (ly-get-elt-property elt 'interfaces))))
         (not (#f (string-match text (ly-get-elt-property elt 'text)))))
    ))

global = \notes{
    \partial 2;
    \key a \major;
    \skip 2;
    \skip 1*2;

#ifndef FAKE_GRACE
    \skip 1;
#else % FAKE_GRACE
    \skip 2.; \partial 32*24;
    \skip 32*24;
#endif % FAKE_GRACE

    \bar "||";
}

treble = \context Voice=treble \notes\relative c''{
    % Broken?
    \property Voice.NoteColumn \push #'horizontal-shift = #0
    \outputproperty #(make-type-checker 'text-item-interface) 
	    #'extra-offset = #'(-6 . 2)
    %% *Style* = Large??
    \property Voice.TextScript \push #'style = #"Large"
    r2^"Allegretto scherzando"
    \property Voice.TextScript \pop #'style
    %2
    \property Voice.Stem \pop #'direction
    \property Voice.Stem \push #'direction = #1
    r4 <cis\arpeggio eis a cis> r2
    %3
    r4 <cis\arpeggio fis a cis> r8.
    \translator Staff=bass
    \outputproperty #(make-text-checker "m")
	    #'extra-offset = #'(-6 . 2)
    cis,16^2^"m.d."( <fis8 fis,> <e! e,!>
    %4
    <)dis,4 a' dis>
    \translator Staff=treble
    \property Voice.Slur \pop #'direction
    \property Voice.Slur \push #'direction = #1
    \property PianoStaff.connectArpeggios = ##t
    \property Voice.TextSpanner \pop #'type

    %% Ghostview is ok, but xdvi shows a solid line
    \property Voice.TextSpanner \push #'line-thickness = #2
    \property Voice.TextSpanner \push #'dash-period = #0.5

    \property Voice.TextSpanner \push #'type = #"dotted-line"
    \property Voice.TextSpanner \push #'edge-height = #'(0 . 1.5)
    \property Voice.TextSpanner \push #'edge-text = #'("8 " . "")
    \property Staff."c0-position" = #-13
    \outputproperty #(make-text-checker "m")
	    #'extra-offset = #'(-6 . 2)
    cis''''4^"m.g."\arpeggio \spanrequest \start "text"  (

#ifndef FAKE_GRACE

    \property Voice.Stem \pop #'direction

    % grace is a mess
    % maybe we should fake this and put 5/4 in this bar?

    \grace {
        )cis8
	\property Grace.Stem \pop #'direction
	\property Grace.Stem \push #'direction = #0
	\property Grace.Beam \push #'space-function = #grace-beam-space-function
	%% urg, dim. during grace dumps core here
        %% [a16-5( fis dis \spanrequest \stop "text" ]
	%% [cis'32 a-1 fis-4 dis] [cis a )fis-2]
        [a16-5( fis dis \spanrequest \stop "text" ]
        \property Staff."c0-position" = #-6
	[cis32 a-1 fis-4 dis] [cis a )fis-2]
    }

#else % FAKE_GRACE 

    \property Score.PaperColumn  \push #'space-factor = #0.6
    \property Score.PaperColumn  \push #'to-musical-spacing-factor = #0.04
    \property Voice.NoteHead \push #'font-size = #-1
    \property Voice.Stem \push #'font-size = #-1
    \property Voice.Stem \push #'length = #6
    \property Voice.Stem \push #'beamed-lengths =
        #(map (lambda (x) (* 1.25 x)) '(0.0 2.5 2.0 1.5))
    \property Voice.Stem \push #'beamed-minimum-lengths =
        #(map (lambda (x) (* 1.25 x)) '(0.0 1.5 1.25 1.0))

    \property Voice.Beam \push #'font-size = #-1
    \property Voice.TextScript \push #'font-size = #-1
    \property Voice.Fingering \push #'font-size = #-1
    \property Voice.Slur \push #'font-size = #-1
    \property Staff.Accidentals \push #'font-size = #-1
    \property Voice.Beam \push #'space-function = #grace-beam-space-function

    )cis16
    \property Voice.Stem \pop #'direction
    \property Voice.Stem \push #'direction = #0
    %% [a16^5( fis dis \spanrequest \stop "text" ]
    %% [cis'32 a-1 fis-4 dis] [cis a )fis-2] s s s
    [a16^5( fis dis \spanrequest \stop "text" ]
    \property Staff."c0-position" = #-6
    [cis32 a^1 fis^4 dis] [cis a )fis-2] s % s s

    \property Voice.NoteHead \pop #'font-size
    \property Voice.Stem \pop #'font-size
    \property Voice.Stem \pop #'length
    \property Voice.Stem \pop #'beamed-lengths
    \property Voice.Stem \pop #'beamed-minimum-lengths
    \property Voice.Beam \pop #'font-size
    \property Voice.TextScript \pop #'font-size
    \property Voice.Fingering \pop #'font-size
    \property Voice.Slur \pop #'font-size
    \property Staff.Accidentals \pop #'font-size
    \property Voice.Beam \pop #'space-function
    \property Score.PaperColumn  \pop #'space-factor
    \property Score.PaperColumn \pop #'to-musical-spacing-factor
#endif % FAKE_GRACE
    

    \property Voice.Stem \pop #'direction
    \property Voice.Stem \push #'direction = #1
    cis'4()bis
    r8
    <a'8( a,> <gis gis,> <fis fis,> <gis gis,> <fis fis,> )e^" "^1^4^5 r|
    r<a8( a,> <gis gis,> <fis fis,> <gis gis,> <fis fis,> )e r|
}

trebleTwo = \context Voice=trebleTwo \notes\relative c''{
    \property Voice.NoteColumn \push #'horizontal-shift = #1
    s2
    s1*2
    s4
    \property Voice.Stem \pop #'direction
    \property Voice.Stem \push #'direction = #-1
    <cis'4\arpeggio a fis dis>

#ifdef FAKE_GRACE
    s32*16
#endif

    \property Voice.NoteColumn \push #'force-hshift = #-0.2
    <e,2 gis, e d>
    % Hmm s/r?
    %r8 cis4. d4
    s8 cis4. d4
    \property Voice.NoteColumn \pop #'force-hshift
    [<cis8( e,> <b-3 d,-1> |
    \property Voice.NoteColumn \push #'force-hshift = #-0.2
    <)a-2 cis,-1>] cis4. d4 
    \property Voice.NoteColumn \pop #'force-hshift
    [<cis8( e,> <b d,> |
    <)a cis,>]
}

bass = \context Voice=bass \notes\relative c{
    \property Voice.Slur \push #'details =
          #'((height-limit . 2.0) (ratio . 0.333) (force-blowfit . 0.5) (beautiful . 5.0))
    \property Voice.Slur \push #'attachment-offset = #'((0 . -3) . (0 . -6))
    \property Voice.Stem \pop #'direction
    \property Voice.Slur \push #'direction = #-1
    % huh, auto-beamer?
    r8. e,16-2( [<a8 a,> <b b,>] <cis4 cis,> |
    %2
    \translator Staff=treble
    \property Voice.Stem \pop #'direction
    \property Voice.Stem \push #'direction = #-1
    \property Voice.slurEndAttachment = #'stem
    <)a''4\arpeggio eis cis> 
    %\stemboth
    \property Voice.slurEndAttachment = ##f
    \translator Staff=bass
    \property Voice.Stem \pop #'direction
    \property Voice.Slur \pop #'y-free
    \property Voice.Slur \push #'y-free = #0.1
    r8. cis,,16( <fis8 fis,> <gis gis,>
    %3
    \property Voice.Stem \pop #'length
    \property Voice.Stem \push #'length = #5
    <a4 a,>
    \translator Staff=treble
    \property Voice.Stem \pop #'length
    \property Voice.Stem \pop #'direction
    \property Voice.Stem \push #'direction = #-1
    <)a'\arpeggio fis cis>
    \translator Staff=bass
    \property Voice.Stem \pop #'direction
    r2
    %4
    \property Voice.Slur \pop #'details
    \property Voice.Slur \pop #'attachment-offset
    \property Voice.Stem \pop #'direction
    \property Voice.Stem \push #'direction = #-1
    <b,,4 b,>
    \clef treble;
    \property Voice.Stem \pop #'direction
    \property Voice.Stem \push #'direction = #0
    <
        %urg: staff-change: ! on dis
        <cis''\arpeggio a fis dis!>
%	{ s8. \clef bass;}
    >

#ifndef FAKE_GRACE
    %Hmm
    %\grace { s16 s s s s32 s s s s \clef bass; s }
    \clef bass;
    \grace { <e,,,32( e,> } <)gis'2 e>
#else
    s4 s8 s32 s  s \clef bass;
    \property Score.PaperColumn  \push #'space-factor = #0.6
    \property Score.PaperColumn  \push #'to-musical-spacing-factor = #0.1
    \property Voice.NoteHead \push #'font-size = #-1
    \property Voice.Stem \push #'font-size = #-1
    \property Voice.Stem \push #'length = #6
    \property Voice.Slur \push #'font-size = #-1
    \property Voice.Slur \push #'attachment-offset = #'((-0.5 . 0) . (0.5 . 0))
    <e,,,32( e,>

    \property Voice.NoteHead \pop #'font-size
    \property Voice.Stem \pop #'font-size
    \property Voice.Stem \pop #'length
    \property Voice.Slur \pop #'font-size
    \property Score.PaperColumn  \pop #'space-factor
    \property Score.PaperColumn \pop #'to-musical-spacing-factor
     <)gis'2 e>
    \property Voice.Slur \pop #'attachment-offset
#endif
    %5
    \property Voice.Slur \pop #'direction
    \property Voice.Slur \push #'direction = #1
    a,8 [e'-5(<)a-2 cis-3>]
    r b,-5 <e4-3 gis-5 d'>
    \property Voice.Slur \pop #'direction
    \property Voice.Slur \push #'direction = #0
    [e,8-5(|
    %6
    )a-2]
    \property Voice.Slur \pop #'direction
    \property Voice.Slur \push #'direction = #1
    [e'(<)a cis>] r b, <e4 gis d'>
    \property Voice.Slur \pop #'direction
    \property Voice.Slur \push #'direction = #0
    [e,8(|
    %7
    )a]
}

bassTwo = \context Voice=bassTwo \notes\relative c{
    \skip 2;
    \skip 1*2;
    \skip 2;

#ifdef FAKE_GRACE
    \skip 32*16;
#endif

    \property Voice.Stem \pop #'direction
    \property Voice.Stem \push #'direction = #1
    \property Voice.Slur \pop #'direction
    \property Voice.Slur \push #'direction = #1

    cis'4()bis
}

middleDynamics = \context Dynamics=middle \notes{
    s8 s16 s\f s4
    s1*2
    %4
    s2

#ifdef FAKE_GRACE
    s32*12
    \outputproperty #(make-type-checker 'dynamic-interface) 
	    #'extra-offset = #'(0 . 1.5)
    s32\> s s \!s
#endif
    s32 
    \outputproperty #(make-type-checker 'text-item-interface) 
	    #'extra-offset = #'(0 . 1.5)
    s-"rall." s s
    s8 s4

    \outputproperty #(make-type-checker 'dynamic-interface) 
	    #'extra-offset = #'(0 . 4)
    %s1\mf-"a tempo"
    s2\mf-"a tempo" s4
    \outputproperty #(make-type-checker 'crescendo-interface) 
	    #'extra-offset = #'(0.5 . -1)
    s\> \!s8
    \outputproperty #(make-type-checker 'dynamic-interface) 
	    #'extra-offset = #'(-1 . 4)
    s8\mf s4 s4 s8\> s32 s s \!s
}

lowerDynamics = \context Dynamics=lower \notes{
    s2
    %2
    s2\sustaindown s8. s16\sustainup s4
    %3
    s2\sustaindown s8. s16\sustainup s4
    %3

#ifndef FAKE_GRACE
    s4\sustaindown s16
    s32 s s\sustainup s
    s32\sustaindown s s s
    s8
#else
    s2\sustaindown
    s32*12
    s32 s s\sustainup s
    s32\sustaindown s s s
#endif

    \property Dynamics.stopSustain = #""
    s4 s16. s32\sustainup

    %5
    s8\sustaindown s s
    \property Dynamics.stopSustain = #"*"
    \property Dynamics.stopStartSustain = #"-P"
    s s\sustainup\sustaindown s s
    s\sustainup

    %6
    \property Dynamics.stopStartSustain = #""
    s8\sustaindown s s
    \property Dynamics.stopStartSustain = #"-P"
    s s\sustainup\sustaindown s s
    s\sustainup
}

\score{
    \context PianoStaff <
        \context Staff=treble <
	    \global
	    \treble
	    \trebleTwo
        >
	\context Dynamics=middle <
	    \global
	    \middleDynamics
	>
        \context Staff=bass <
	    \clef bass;
	    \global
	    \bass
	    \bassTwo
        >
	\context Dynamics=lower <
	    \global
	    \lowerDynamics
	>
    >
    \paper {
	%%BURP
	magnification_italic = 1.;
	\translator {
	    \ScoreContext
	    TimeSignature \push #'style = #"C"
	    SpacingSpanner \push #'maximum-duration-for-spacing = #(make-moment 1 4)

	    \remove Bar_number_engraver;
        }
	\translator {
	    \type "Engraver_group_engraver";
	    \name Dynamics;
	    \consists "Output_property_engraver";
	    Generic_property_list = #generic-voice-properties
	    \consists "Property_engraver";
	    DynamicsMinimumVerticalExtent = #(cons -3 -3)
	    VerticalAlignment \push #'threshold = #'(9 . 9) 

	    startSustain = #"Ped."
	    stopSustain = #"*"
	    stopStartSustain = #"*Ped."
	    startUnaChorda = #"una chorda"
	    stopUnaChorda = #"tre chorde"
	    
	    \consists "Piano_pedal_engraver";
	    \consists "Script_engraver";
	    \consists "Dynamic_engraver";
	    \consists "Text_engraver";
	    %GURGURGU, text is initialised using TextScript
	    TextScript \push #'style = #"italic"
	    %%% TextScript \push #'font-size = #2

	    \consists "Skip_req_swallow_translator";

	    \consistsend "Axis_group_engraver";
    	}

	\translator {
	    \PianoStaffContext
	    \accepts Dynamics;
	    VerticalAlignment \push #'threshold = #'(7 . 7)
        }
	\translator {
	    \GraceContext
	    Stem \push #'flag-style = #""
        }
    }
}
