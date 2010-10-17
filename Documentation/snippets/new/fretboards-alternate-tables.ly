\version "2.13.36"

\header {
  lsrtags = "fretted-strings"

  texidoc = "
Alternate fretboard tables can be created.  These would be used in
order to have alternate fretboards for a given chord.

In order to use an alternate fretboard table, the table must first
be created.  Fretboards are then added to the table.

The table to be used in displaying predefined fretboards is selected
by the property @code{\predefinedDiagramTable}.
"

  doctitle = "Alternate fretboard tables"
}

\include "predefined-guitar-fretboards.ly"

#(define custom-fretboard-table-one (make-hash-table 101))

#(define custom-fretboard-table-two (make-hash-table 101))

\storePredefinedDiagram #custom-fretboard-table-one
                        \chordmode{c}
                        #guitar-tuning
                        "3-(;3;5;5;5;3-);"

\storePredefinedDiagram #custom-fretboard-table-two
                        \chordmode{c}
                        #guitar-tuning
                        "x;3;5;5;5;o;"

<<
  \chords {
    c1 |
    c1 |
    c1
  }
  \new FretBoards {
    \chordmode {
      \set predefinedDiagramTable = #default-fret-table
      c1
      \set predefinedDiagramTable = #custom-fretboard-table-one
      c1
      \set predefinedDiagramTable = #custom-fretboard-table-two
      c1
    }
  }
  \new Staff {
    \clef "treble_8"
    \chordmode {
      c1 |
      c1 |
      c1
    }
  }
>>
