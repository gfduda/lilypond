/*
  lilypond, (c) 1996,97 Han-Wen Nienhuys
*/
#ifndef LOOKUPSYMS_HH
#define LOOKUPSYMS_HH

#include "symbol.hh"
#include "fproto.hh"
#include "scalar.hh"

/// intuitive interface to symbol table
struct Lookup {
    Symtables *symtables_;
    String texsetting;
    /* *************** */
    void add(String, Symtable*);
    void print()const;
    Real internote()const;

    Symbol linestaff(int n, Real w)const;
    Symbol fill(Box b)const;
    Symbol beam_element(int,int,Real=0)const;

    /// round slope to closest TeXslope
    Symbol beam(Real&,Real)const;

    /**
      pos == 3 : 3 lines above staff (extending below note)

      pos == -3: below staff
      */
    Symbol streepjes(int pos)const;

    Symbol meter(Array<Scalar>)const;
    Symbol stem(Real y1_pos, Real y2_pos)const;
    Symbol rule_symbol(Real height, Real width)const;
    Symbol accidental(int)const;
    Symbol ball(int)const;
    Symbol flag(int)const;
    Symbol rest(int)const;
    Symbol clef(String)const;
    Symbol bar(String)const;
    Symbol dots(int)const;
    Symbol slur(int dy, Real &dx, int dir)const;
    Symbol half_slur(int dy, Real &dx, int dir, int xpart)const;
    Symbol half_slur_middlepart(Real &dx, int dir)const;
    Symbol big_slur(int dy, Real &dx, int dir)const;
    Symbol text(String style, String text, int align = 1)const;
    Symbol script(String idx)const;
    Symbol hairpin(Real & width, bool decresc)const;
    Symbol dynamic(String)const;
    Lookup();
    Lookup(Lookup const &);
    ~Lookup();
};

#endif
