\score{
\context Staff \notes\relative c''{
	c1 
	\context Score {
		\outputproperty #(make-type-checker 'Mark) 
		#'extra-offset = #'(-1 . 4)
	}
	\mark A;
	d
	\mark ;
	e
}
\paper{
	linewidth=-1.0;
	\translator {
		\ScoreContext
		\consists "Mark_engraver";
	}
}
}
