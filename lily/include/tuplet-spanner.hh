/*
  plet-spanner.hh -- part of GNU LilyPond

  (c)  1997--2000 Jan Nieuwenhuizen <janneke@gnu.org>
*/

#ifndef Tuplet_spanner_HH
#define Tuplet_spanner_HH

#include "lily-guile.hh"

/*

    TODO: quantise, we don't want to collide with staff lines.
    (or should we be above staff?)

  todo: handle breaking elegantly.
*/
class Tuplet_spanner
{
public:
  DECLARE_SCHEME_CALLBACK(brew_molecule, (SCM ));
  static void set_interface (Score_element*);  
  static bool has_interface (Score_element*);

  static void add_column (Score_element*me,Item*);
  static void add_beam (Score_element*me,Score_element*);

  static void calc_dy (Score_element*,Real *) ;
  static void calc_position_and_height (Score_element*,Real*,Real *dy);
  
  DECLARE_SCHEME_CALLBACK(after_line_breaking, (SCM ));

  static Direction get_default_dir (Score_element*);
};

#endif // Tuplet_spanner_HH

