/*
  main.cc -- implement main: entrypoints

  source file of the GNU LilyPond music typesetter

  (c)  1997--1999 Han-Wen Nienhuys <hanwen@cs.uu.nl>
*/

#include <stdlib.h>
#include <iostream.h>
#include <assert.h>
#include <locale.h>
#include "lily-guile.hh"
#include "lily-version.hh"

#include "all-fonts.hh"
#include "proto.hh"
#include "dimensions.hh"
#include "getopt-long.hh"
#include "misc.hh"
#include "string.hh"
#include "main.hh"
#include "file-path.hh"
#include "config.hh"
#include "file-results.hh"
#include "debug.hh"
#include "lily-guile.hh"
#include "paper-def.hh"
#include "midi-def.hh"
#include "global-ctor.hh"

#if HAVE_GETTEXT
#include <libintl.h>
#endif


bool version_ignore_global_b = false;
bool no_paper_global_b = false;
bool no_timestamps_global_b = false;
bool find_old_relative_b = false;

char const* output_global_ch = "tex";
All_font_metrics *all_fonts_global_p;

String default_outname_base_global =  "lelie";
String outname_str_global;
String init_str_global;

int default_count_global;
File_path global_path;

bool safe_global_b = false;
bool experimental_features_global_b = false;
bool dependency_global_b = false;

int exit_status_i_;

Getopt_long * oparser_global_p = 0;

String distill_inname_str (String name_str, String& ext_r);

Long_option_init theopts[] = {
  {0, "about", 'a'},
  {1, "output", 'o'},
  {0, "warranty", 'w'},
  {0, "help", 'h'},
  {0, "test", 't'},
  {0, "debug", 'D'},
  {1, "init", 'i'},
  {1, "include", 'I'},
  {0, "no-paper", 'M'},
  {0, "dependencies", 'd'},
  {0, "no-timestamps", 'T'},
  {0, "find-old-relative", 'Q'},
  {0, "ignore-version", 'V'},
  {1, "output-format", 'f'},
  {0, "safe", 's'},
  {0,0,0}
};

void
usage ()
{
  cout << _f ("Usage: %s [OPTION]... [FILE]...", "lilypond") << '\n';
  cout << _ ("Typeset music and or play MIDI from FILE or <stdin>");
  cout << '\n';
  cout << '\n';
  cout << _ ("Options:");
  cout << '\n';
  cout  << _ (
    "  -a, --about            about LilyPond\n"
    );
  cout  << _ (
    "  -D, --debug            enable debugging output\n"
    );
  cout  << _ (
    "  -d, --dependencies     write Makefile dependencies for every input file\n"
    );
  cout  << _ (
    "  -h, --help             this help\n"
    );
  cout  << _ (
    "  -f, --output-format=X  use output format X\n"
    );
  cout  << _ (
    "  -I, --include=DIR      add DIR to search path\n"
    );
  cout  << _ (
    "  -i, --init=FILE        use FILE as init file\n"
    );
  cout  << _ (
    "  -M, --no-paper         produce midi output only\n"
    );
  cout  << _ (
    "  -o, --output=FILE      set FILE as default output base\n"
    );
  cout  << _ (
    "  -Q, --find-old-relative show all changes in relative syntax\n"
    );
  cout << _ (
    "  -s, --safe             inhibit file output naming and exporting TeX  macros\n");
  cout  << _ (
    "  -t, --test             switch on experimental features\n"
    );
  cout  << _ (
    "  -T, --no-timestamps    don't timestamp the output\n"
    );
  cout  << _ (
    "  -V, --ignore-version   ignore mudela version\n"
    );
  cout  << _ (
	      "  -w, --warranty         show warranty and copyright\n"
	      );
  cout << '\n';
  cout << _ ("GNU LilyPond was compiled with the following settings:");
  cout << '\n';
  cout <<
#ifdef NDEBUG
    "NDEBUG "
#endif
#ifdef NPRINT
    "NPRINT "
#endif
#ifdef STRING_UTILS_INLINED
    "STRING_UTILS_INLINED "
#endif
    "datadir=" DIR_DATADIR
    "\n"
    "localedir=" DIR_LOCALEDIR

    "\n";

  ;
}

void
about ()
{
  cout << '\n';
  cout << 
#include "BLURB.hh"
    cout << '\n';
  cout << _ ("GNU LilyPond is Free software, see --warranty");
  cout << '\n';
  cout << '\n';
  cout << _f ("Copyright (c) %s by", "1996--1999");
  cout << '\n';
  cout << "  " + _ ("Han-Wen Nienhuys <hanwen@cs.uu.nl>") + "\n";
  cout << "  " + _ ("Jan Nieuwenhuizen <janneke@gnu.org>") + "\n";
  cout << '\n';
}

void
notice ()
{
  cout << '\n';
  cout << _ ("GNU LilyPond -- The GNU Project music typesetter");
  cout << '\n';
  cout << _f ("Copyright (c) %s by", "1996--1999");
  cout << '\n';
  cout << "  " + _ ("Han-Wen Nienhuys <hanwen@cs.uu.nl>") + "\n";
  cout << "  " + _ ("Jan Nieuwenhuizen <janneke@gnu.org>") + "\n";
  cout << '\n';
  cout << _ (
	     "    This program is free software; you can redistribute it and/or\n"
	     "modify it under the terms of the GNU General Public License version 2\n"
	     "as published by the Free Software Foundation.\n"
	     "\n"
	     "    This program is distributed in the hope that it will be useful,\n"
	     "but WITHOUT ANY WARRANTY; without even the implied warranty of\n"
	     "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU\n"
	     "General Public License for more details.\n"
	     "\n"
	     "    You should have received a copy (refer to the file COPYING) of the\n"
	     "GNU General Public License along with this program; if not, write to\n"
	     "the Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139,\n"
	     "USA.\n");
}

void
identify ()
{
  *mlog << gnu_lilypond_version_str () << endl;
}

void
setup_paths ()
{
  // facilitate binary distributions
  char const *env_lily = getenv ("LILYPONDPREFIX");
  String prefix_directory;
  if (env_lily)
    prefix_directory = env_lily;

#if HAVE_GETTEXT
  setlocale (LC_ALL, ""); /* enable locales */
  setlocale (LC_NUMERIC, "C"); /* musn't have comma's in TeX output... */
  String lily_locale_dir;
  String name (PACKAGE);
  name.to_lower ();
  if (!prefix_directory.empty_b())
    {
      lily_locale_dir = prefix_directory + "/share/locale";
      bindtextdomain (name.ch_C (), lily_locale_dir.ch_C());
    }
  else
    bindtextdomain (name.ch_C (), DIR_LOCALEDIR);
  textdomain (name.ch_C ());
#endif

  global_path.add ("");
  // must override (come before) "/usr/local/share/lilypond"!
  char const *env_sz = getenv ("LILYINCLUDE");
  if (env_sz)
    global_path.parse_path (env_sz);


  char *suffixes[] = {"ly", "afm", "scm", "tfm", "cmtfm", 0};
  for (char **s = suffixes; *s; s++){
    if (!prefix_directory.empty_b())
      global_path.add (prefix_directory + to_str ('/') + String (*s));
    else
      global_path.add (String (DIR_DATADIR) + to_str ('/') + String(*s));
  }
}


void
main_prog (int argc, char **argv)
{
  /*
    need to do this first. Engravers use lily.scm contents.
   */
  read_lily_scm_file ( "lily.scm");
  cout << endl;

  call_constructors ();
  default_outname_base_global = "lelie";
  all_fonts_global_p = new All_font_metrics (global_path.str ());
  
  int p=0;
  const char *arg ;
  while ((arg= oparser_global_p->get_next_arg ()))
    {
      
      if (outname_str_global == "")
	{
	  Midi_def::reset_default_count ();
	  Paper_def::reset_default_count ();
	}
      String f (arg);
      String i;
      f = distill_inname_str (f, i);
      if (f == "-")
	default_outname_base_global = "-";
      else
	{
	  String a,b,c,d;
	  split_path (f, a, b, c, d);
	  default_outname_base_global = c;
	}
      if (outname_str_global.length_i ())
	default_outname_base_global = outname_str_global;
      if (init_str_global.length_i ())
	i = init_str_global;
      else
	i = "init" + i;
      do_one_file (i, f);
      p++;
    }
  if (!p)
    {
      String i;
      if (init_str_global.length_i ())
	i = init_str_global;
      else
	i = "init.ly";
      default_outname_base_global = "-";
      if (outname_str_global.length_i ())
	default_outname_base_global = outname_str_global;
      do_one_file (i, default_outname_base_global);
    }
  delete oparser_global_p;
  exit( exit_status_i_);
}


int
main (int argc, char **argv)
{
  identify ();
  debug_init ();		// should be first
  setup_paths ();

  oparser_global_p = new Getopt_long(argc, argv,theopts);
  while (Long_option_init const * opt = (*oparser_global_p)())
    {
      switch (opt->shortname)
	{
	case 't':
	  experimental_features_global_b = true;
	  *mlog << "*** enabling experimental features, you're on your own now ***\n";
	  break;
	case 'o':
	  outname_str_global = oparser_global_p->optional_argument_ch_C_;
	  break;
	case 'w':
	  notice ();
	  exit (0);
	  break;
	case 'f':
	  output_global_ch = oparser_global_p->optional_argument_ch_C_;
	  break;
	case 'Q':
	  find_old_relative_b= true;
	  break;
	case 'I':
	  global_path.push (oparser_global_p->optional_argument_ch_C_);
	  break;
	case 'i':
	  init_str_global = oparser_global_p->optional_argument_ch_C_;
	  break;
	case 'a':
	  about ();
	  exit (0);
	case 'h':
	  usage ();
	  exit (0);
	  break;
	case 'V':
	  version_ignore_global_b = true;
	  break;
	case 's':
	  safe_global_b = true;
	  break;
	case 'd':
	  dependency_global_b = true;
	  break; 
	case 'D':
	  set_debug (true);
	  break;
	case 'M':
	  no_paper_global_b = true;
	  break;
	case 'T':
	  no_timestamps_global_b = true;
	  break;
	default:
	  assert (false);
	  break;
	}
    }

#ifdef WINNT
  gh_enter (argc, argv, main_prog);
#else
  gh_enter (argc, argv, (void(*)())main_prog);
#endif

  return 0;			// unreachable
}

/**
  make input file name from command arg.

  @input file name

  @output file name with added default extension. "" is stdin.
          in reference argument: the extension. ".ly" if none
 */
String
distill_inname_str (String name_str, String& ext_r)
{
  String str = name_str;
  if (str.length_i ())
    {
      if (str != "-")
	{
	  String a,b,c;
	  split_path (str,a,b,c,ext_r);

	  // add extension if not present.
	  char const* extensions[] = {"", "", ".ly", ".fly", ".sly", 0};
	  extensions[0] = ext_r.ch_C ();
	  for (int i = 0; extensions[i]; i++)
	    {
	      if (!global_path.find (a+b+c+extensions[i]).empty_b ())
		{
		  ext_r = extensions[i];
		  break;
		}
	    }
	  str = a+b+c+ext_r;
	}
    }
  else 
    {
      str = "-";
      ext_r = ".ly";
    }
  return str;
}

