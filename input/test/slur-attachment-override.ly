\version "1.7.18"

\header{
texidoc="@cindex Slur Attachment Override
In some cases you may want to set slur attachments by hand. "
}

fragment = \notes {
  \property Voice.autoBeaming = ##f
  \property Voice.Stem \set #'direction = #1
  \property Voice.Slur \set #'direction = #1
  d'32( f'4  d8..-)
  \property Voice.Slur \set #'attachment = #'(stem . stem)
  d,32( f'4  d8.-)
}


\score {
	\notes\relative c \fragment
	\paper { raggedright = ##t} 
}
%% new-chords-done %%
