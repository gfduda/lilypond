/*   
  note-head-line-engraver.cc -- implement Note_head_line_engraver
  
  source file of the GNU LilyPond music typesetter
  
  (c) 2000 Jan Nieuwenhuizen <janneke@gnu.org>
 */

#include "engraver.hh"
#include "group-interface.hh"
#include "item.hh"
#include "musical-request.hh"
#include "spanner.hh"
#include "stem.hh"
#include "rhythmic-head.hh"
#include "side-position-interface.hh"
#include "staff-symbol-referencer.hh"
#include "translator-group.hh"

/**
   Create line-spanner grobs for glissandi (and possibly other) lines
   that connect note heads.
 */

class Note_head_line_engraver : public Engraver
{
public:
  VIRTUAL_COPY_CONS (Translator);
  Note_head_line_engraver ();

protected:
  virtual void acknowledge_grob (Grob_info);
  virtual void create_grobs ();
  virtual void stop_translation_timestep ();
  virtual bool try_music (Music *);

private:
  Spanner* line_; 
  Request* req_;
  Request* last_req_;
  Translator* last_staff_;
  bool follow_;
  Grob* head_;
  Grob* last_head_;
};

Note_head_line_engraver::Note_head_line_engraver ()
{
  line_ = 0;
  req_ = 0;
  last_req_ = 0;
  follow_ = false;
  head_ = 0;
  last_head_ = 0;
  last_staff_ = 0;
}

bool
Note_head_line_engraver::try_music (Music* m)
{
  if (!req_)
    {
      if (Glissando_req *r = dynamic_cast<Glissando_req*> (m))
	{
	  req_ = r;
	  return true;
	}
    }
  return false;
}

void
Note_head_line_engraver::acknowledge_grob (Grob_info info)
{
  if (Rhythmic_head::has_interface (info.elem_l_))
    {
      last_head_ = head_;
      head_ = info.elem_l_;
      if (to_boolean (get_property ("followThread")))
	{
    	  Translator* staff = daddy_trans_l_ && daddy_trans_l_->daddy_trans_l_
	    ? daddy_trans_l_->daddy_trans_l_->daddy_trans_l_ : 0;
	  if (staff != last_staff_)
	    {
	      if (last_head_)
		follow_ = true;
	      last_staff_ = staff;
	    }
	}
    }
}

static Grob*
beam_l (Grob *h)
{
  if (Grob *s = Rhythmic_head::stem_l (h))
    return Stem::beam_l (s);
  return 0;
}

void
Note_head_line_engraver::create_grobs ()
{
  if (!line_ && (follow_ || last_req_) && last_head_ && head_
      && (last_head_ != head_))
    {
      /* Don't follow if there's a beam.

	 Hmm, this doesn't work, as head_ does not yet have a beam.
	 Should probably store follow_ in line_, and suicide at some
	 later point */
      if (!(follow_
	    && beam_l (last_head_) && beam_l (last_head_) == beam_l (head_)))
	{
	  if (follow_)
	    line_ = new Spanner (get_property ("FollowThread"));
	  else
	    line_ = new Spanner (get_property ("Glissando"));
	  
	  line_->set_bound (LEFT, last_head_);
	  line_->set_bound (RIGHT, head_);
	  
	  /* Note, mustn't set y-parent of breakable symbol to simple item:
	     one of the two broken parts won't have an y-parent! */
	  /* X parent is set by set_bound */
	  line_->set_parent (Staff_symbol_referencer::staff_symbol_l (last_head_),
			     Y_AXIS);
	  
	  announce_grob (line_, last_req_);
	}
      
      last_req_ = 0;
      follow_ = false;
      last_head_ = 0;
    }
}

void
Note_head_line_engraver::stop_translation_timestep ()
{
  if (line_)
    {
      typeset_grob (line_);
      line_ = 0;
    }
  last_req_ = req_;
  req_ = 0;
}


ADD_THIS_TRANSLATOR (Note_head_line_engraver);

