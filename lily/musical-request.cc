/*
  request.cc -- implement all musical requests.

  source file of the GNU LilyPond music typesetter

  (c)  1997--1999 Han-Wen Nienhuys <hanwen@cs.uu.nl>
*/

#include "musical-request.hh"
#include "misc.hh"
#include "debug.hh"
#include "script-def.hh"
#include "text-def.hh"
#include "music-list.hh"




void
Musical_req::do_print () const{}
void
Tie_req::do_print () const{}







void
Musical_span_req::do_print () const
{
  Span_req::do_print ();
}
	     

void
Span_req::do_print () const
{
#ifndef NPRINT
  DOUT << spantype_;
#endif
}



Spacing_req::Spacing_req ()
{
  next = 0;
  distance = 0;
  strength = 0;
}

void
Spacing_req::do_print () const
{
#ifndef NPRINT
  DOUT << "next " << next << "dist " << distance << "strength\n";
#endif
}



Abbreviation_req::Abbreviation_req ()
{
  type_i_ = 0;
}

void
Abbreviation_req::do_print () const
{
#ifndef NPRINT
  DOUT << "type " << type_i_ << '\n';
#endif
}




void
Blank_req::do_print () const
{
  Spacing_req::do_print ();
}

Melodic_req::Melodic_req ()
{
}

void
Melodic_req::transpose (Musical_pitch delta)
{
  pitch_.transpose (delta);
  
  if (abs (pitch_.accidental_i_) > 2)
    {
	warning (_f ("transposition by %s makes accidental larger than two",
	  delta.str ()));
    }
}



bool
Melodic_req::do_equal_b (Request*r) const
{
  Melodic_req* m= dynamic_cast <Melodic_req *> (r);
  return m&& !compare (*m, *this);
}

int
Melodic_req::compare (Melodic_req const &m1 , Melodic_req const&m2)
{
  return Musical_pitch::compare (m1.pitch_, m2.pitch_);
}

void
Melodic_req::do_print () const
{
pitch_.print ();
}


Tonic_req::Tonic_req ()
{
}

void
Tonic_req::do_print () const
{
#ifndef NPRINT
  Melodic_req::do_print ();
#endif
}

int
Rhythmic_req::compare (Rhythmic_req const &r1, Rhythmic_req const &r2)
{
  return (r1.length_mom () - r2.length_mom ());
}

bool
Rhythmic_req::do_equal_b (Request*r) const
{
  Rhythmic_req* rh = dynamic_cast <Rhythmic_req *> (r);

  return rh && !compare (*this, *rh);
}




void
Rhythmic_req::do_print () const
{
#ifndef NPRINT
  DOUT << "duration { " <<duration_.str () << "}";
#endif
}


Moment
Rhythmic_req::length_mom () const
{
  return duration_.length_mom ();
}

void
Rhythmic_req::compress (Moment m)
{
  duration_.compress (m);
}

void
Lyric_req::do_print () const
{
  Rhythmic_req::do_print ();
}


bool
Note_req::do_equal_b (Request*r) const
{
  Note_req *n = dynamic_cast<Note_req*> (r);
  return n&& Rhythmic_req::do_equal_b (n) && Melodic_req::do_equal_b (n);
}


Note_req::Note_req ()
{
  cautionary_b_ = false;
  forceacc_b_ = false;
}



void
Note_req::do_print () const
{
#ifndef NPRINT
  Melodic_req::do_print ();
  if (cautionary_b_)
    {
	DOUT << " force cautionary accidental\n";
    }
  else if (forceacc_b_)
    {
	DOUT << " force accidental\n";
    }
  Rhythmic_req::do_print ();
#endif
}

void
Rest_req::do_print () const
{
      Rhythmic_req::do_print ();
}

void
Multi_measure_rest_req::do_print () const
{
      Rhythmic_req::do_print ();
}


void
Beam_req::do_print () const
{
}

Abbreviation_beam_req::Abbreviation_beam_req ()
{
  type_i_ = 0;
}

void
Abbreviation_beam_req::do_print () const
{
}


void
Slur_req::do_print () const
{
}





Extender_req::Extender_req ()
{
}

void
Extender_req::do_print () const
{
}


bool
Span_req::do_equal_b (Request*r) const
{
  Span_req * s = dynamic_cast <Span_req *> (r);
  return s && spantype_ == s->spantype_;
}

Span_req::Span_req ()
{
  spantype_ = CENTER;
}

Script_req::Script_req (Script_req const&s)
{
  dir_ = s.dir_;
  scriptdef_p_ = s.scriptdef_p_ ? s.scriptdef_p_->clone () : 0;
}

/*
  don't check dirs?

  (d1.dir_ == d2.dir_)
 */
bool
Script_req::do_equal_b (Request*r) const
{
  Script_req * s = dynamic_cast <Script_req *> (r);
  return s &&  scriptdef_p_->equal_b (*s->scriptdef_p_);
}

Script_req::Script_req ()
{
  dir_ = CENTER;
  scriptdef_p_ = 0;
}




void
Script_req::do_print () const
{
#ifndef NPRINT
  DOUT << " dir " << dir_;
  scriptdef_p_->print ();
#endif
}

void
Musical_script_req::do_print () const
{
  Script_req::do_print ();
}

Script_req::~Script_req ()
{
  delete scriptdef_p_;
}

void
Skip_req::do_print () const
{
#ifndef NPRINT
  DOUT << "duration: " << length_mom ();
#endif
}

void
Dynamic_req::do_print () const
{
  Musical_req::do_print ();
}

void
Absolute_dynamic_req::do_print () const
{
#ifndef NPRINT
  DOUT << " loudness " <<loudness_str_ ;
#endif
}

bool
Absolute_dynamic_req::do_equal_b (Request *r) const
{
  Absolute_dynamic_req *a = dynamic_cast <Absolute_dynamic_req *> (r);
  return a&& loudness_str_ == a->loudness_str_;
}

Absolute_dynamic_req::Absolute_dynamic_req ()
{
  loudness_str_ = "fm";		// yes, "illegal" on purpose.
}



bool
Span_dynamic_req::do_equal_b (Request *req) const
{
  Span_dynamic_req * s = dynamic_cast <Span_dynamic_req *> (req);

  return s&& Span_req::do_equal_b (req) && s->dynamic_dir_ == dynamic_dir_;
}

Span_dynamic_req::Span_dynamic_req ()
{
  dynamic_dir_  = CENTER;
}

void
Span_dynamic_req::do_print () const
{
#ifndef NPRINT
  Span_req::do_print ();
  DOUT << "softer/louder: " << dynamic_dir_;
#endif
}



