/*
  multi_measure_rest-engraver.hh -- declare Multi_measure_rest_engraver

  source file of the GNU LilyPond music typesetter

  (c) 1998--1999 Jan Nieuwenhuizen <janneke@gnu.org>
*/

#ifndef MULTI_MEASURE_REST_ENGRAVER_HH
#define MULTI_MEASURE_REST_ENGRAVER_HH

#include "engraver.hh"
#include "moment.hh"

/**
 */
class Multi_measure_rest_engraver : public Engraver
{
public:
  VIRTUAL_COPY_CONS(Translator);
  
  Multi_measure_rest_engraver ();

protected:
  virtual void acknowledge_element (Score_element_info i);
  virtual void do_process_requests ();
  virtual bool do_try_music (Music*);
  virtual void do_pre_move_processing ();
  virtual void do_post_move_processing ();

private:
  Drul_array<Moment> rest_moments_;
  
  int start_measure_i_;
  Multi_measure_rest_req* multi_measure_req_l_;
  Multi_measure_rest* mmrest_p_;
  Multi_measure_rest* lastrest_p_;
};
#endif // MULTI_MEASURE_REST_ENGRAVER_HH
