/*
  bar.hh -- part of LilyPond

  (c) 1996 Han-Wen Nienhuys
*/

#ifndef BAR_HH
#define BAR_HH
#include "item.hh"

struct Bar: Item {
    String type;
    
    Bar(String type);
    void preprocess();
};
#endif // BAR_HH

