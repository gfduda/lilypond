\version "2.7.39"


startGraceMusic =  {
}

stopGraceMusic =  { 
}

startAppoggiaturaMusic =
 {
    s1*0(
}

stopAppoggiaturaMusic =  { 
    s1*0)
}

startAcciaccaturaMusic =  {
    s1*0(
    \override Stem  #'stroke-style = #"grace"
}

stopAcciaccaturaMusic =  {
    \revert Stem #'stroke-style
    s1*0)
}
