
/*
  pango-font.hh -- declare Pango_font

  source file of the GNU LilyPond music typesetter

  (c) 2004 Han-Wen Nienhuys <hanwen@xs4all.nl>

*/

#ifndef PANGO_FONT_HH
#define PANGO_FONT_HH

#include "config.hh"

#ifdef HAVE_PANGO16

#include <pango/pango.h>
#include <pango/pangoft2.h>
#include "font-metric.hh"

struct Pango_font : Font_metric
{
  PangoContext *context_;
  PangoAttrList *attribute_list_;
  Real scale_;
public:
  Stencil text_stencil (String) const;
  Pango_font (PangoFT2FontMap *,
	      int dpi, 
	      Direction leftright,
	      PangoFontDescription *);
  ~Pango_font ();
};
PangoFontDescription* 
symbols_to_pango_font_description(SCM family,
				  SCM style,
				  SCM variant,
				  SCM weight,
				  SCM stretch,
				  SCM size);

#endif
#endif /* PANGO_FONT_HH */

