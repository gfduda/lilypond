/*
  lookup.hh -- declare Lookup

  source file of the GNU LilyPond music typesetter

  (c) 1997--2000 Han-Wen Nienhuys <hanwen@cs.uu.nl>
  Jan Nieuwenhuizen <janneke@gnu.org>
*/

#ifndef LOOKUP_HH
#define LOOKUP_HH

#include "smobs.hh"
#include "lily-guile.hh"
#include "string.hh"
#include "molecule.hh"
#include "flower-proto.hh"
#include "direction.hh"
#include "box.hh"

/**
   handy interface to symbol table
   TODO: move this into GUILE?
 */
class Lookup
{
  Lookup ();
  Lookup (Lookup const&);
  DECLARE_SIMPLE_SMOBS(Lookup,);  
public:

  static SCM make_lookup ();
  String font_name_;
  Adobe_font_metric * afm_l_;

  Molecule afm_find (String, bool warn=true) const;
  Molecule accordion (SCM arg, Real interline_f) const;

  static Molecule frame (Box b, Real thick);
  static Molecule slur (Bezier controls, Real cthick, Real thick) ;
  static Molecule beam (Real, Real, Real) ;
  static Molecule dashed_slur (Bezier, Real thick, Real dash) ;
  static Molecule blank (Box b) ;
  static Molecule filledbox (Box b) ;  
};
Lookup* unsmob_lookup (SCM);
#endif // LOOKUP_HH
