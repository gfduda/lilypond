# -*-python-*-

import glob
import os
import string

Import ('env')

# junkme
srcdir = env['srcdir']

def join_path (path, infix=os.pathsep, prefix = ''):
	def dir (x):
		if x and x[0] == '#':
			return srcdir + x[1:]
		return x
	return string.join (map (lambda x: prefix + dir (x), path), infix)

env['join_path'] = join_path

env['MAKEINFO_INCLUDES'] = join_path (env['MAKEINFO_PATH'], '', ' -I')
a = '$MAKEINFO $__verbose $MAKEINFO_INCLUDES --no-split --no-headers \
--output=$TARGET $SOURCE'
TXT = Builder (action = a, suffix = '.txt', src_suffix = '.texi')
env.Append (BUILDERS = {'TXT': TXT})

a = '$MAKEINFO $__verbose $MAKEINFO_INCLUDES --output=$TARGET $SOURCE'
INFO = Builder (action = a, suffix = '.info', src_suffix = '.texi')
env.Append (BUILDERS = {'INFO': INFO})

a = '$MAKEINFO $__verbose $MAKEINFO_INCLUDES  --html --no-split --no-headers \
--css-include=$srcdir/Documentation/texinfo.css --output=$TARGET $SOURCE'
HTML = Builder (action = a, suffix = '.html', src_suffix = '.texi')
env.Append (BUILDERS = {'HTML': HTML})


env['LILYPOND_BOOK_INCLUDES'] = join_path (env['LILYPOND_BOOK_PATH'], '',
					   ' --include=')

# UGHR, lilypond.py uses lilypond-bin from PATH
env.PrependENVPath ('PATH',
		    os.path.join (env['absbuild'], env['out'], 'usr/bin'))

if os.environ.has_key ('TEXMF'):
	env.Append (ENV = {'TEXMF' : os.environ['TEXMF']})
env.Append (ENV = {'TEXMF' : '{$LILYPONDPREFIX,' \
		   + os.popen ('kpsexpand \$TEXMF').read ()[:-1] + '}' })

if os.environ.has_key ('LD_LIBRARY_PATH'):
	env.Append (ENV = {'LD_LIBRARY_PATH' : os.environ['LD_LIBRARY_PATH']})
if os.environ.has_key ('GUILE_LOAD_PATH'):
	env.Append (ENV = {'GUILE_LOAD_PATH' : os.environ['GUILE_LOAD_PATH']})

env.Append (PYTHONPATH = [os.path.join (env['absbuild'], env['out'],
					'usr/lib/python'),
			  os.path.join (srcdir, 'buildscripts'),
			  os.path.join (srcdir, 'python')])
env.Append (ENV = { 'PYTHONPATH' : string.join (env['PYTHONPATH'],
						os.pathsep) } )

a = ['${__set_x}rm -f $$(grep -LF "\lilypondend" ${TARGET.dir}/lily-*.tex 2>/dev/null);',
     'LILYPONDPREFIX=$LILYPONDPREFIX \
     $PYTHON $LILYPOND_BOOK $__verbose \
     --include=${TARGET.dir} $LILYPOND_BOOK_INCLUDES \
     --process="$LILYPOND_BIN $LILYPOND_BOOK_INCLUDES" \
     --output=${TARGET.dir} --format=$LILYPOND_BOOK_FORMAT \
     $LILYPOND_BOOK_FLAGS \
     $SOURCE']
TEXI = Builder (action = a, suffix = '.texi', src_suffix = '.tely')
env.Append (BUILDERS = {'TEXI': TEXI})

a = 'cd ${TARGET.dir} \
&& texi2dvi --batch $TEXINFO_PAPERSIZE_OPTION ${SOURCE.file}'
texi2dvi = Builder (action = a, suffix = '.dvi', src_suffix = '.texi')
env.Append (BUILDERS = {'Texi2dvi': texi2dvi})

env.Append (DVIPSFLAGS = '-Ppdf -u+lilypond.map -u+ec-mftrace.map')

env ['DVIPS_PAPERSIZE'] = 'a4'
a = ['dvips $DVIPSFLAGS -o ${TARGET}.pdfps -t $DVIPS_PAPERSIZE $SOURCE',
     'ps2pdf -sPAPERSIZE=$DVIPS_PAPERSIZE ${TARGET}.pdfps $TARGET']
dvi2pdf = Builder (action = a, suffix = '.pdf', src_suffix = '.dvi')
env.Append (BUILDERS = {'Dvi2pdf': dvi2pdf})

a = 'convert $SOURCE $TARGET'
png2eps = Builder (action = a, suffix = '.eps', src_suffix = '.png')
env.Append (BUILDERS = {'Png2eps': png2eps})

def add_ps_target (target, source, env):
	base = os.path.splitext (str (target[0]))[0]
	return (target + [base + '.ps'], source)

a = '${set__x}LILYPONDPREFIX=$LILYPONDPREFIX \
$PYTHON $LILYPOND_PY${__verbose} \
--include=${TARGET.dir} \
--output=${TARGET.base} $SOURCE'
lilypond = Builder (action = a, suffix = '.pdf', src_suffix = '.ly')
##		    emitter = add_ps_target)
env.Append (BUILDERS = {'LilyPond': lilypond})

a = '${set__x}LILYPONDPREFIX=$LILYPONDPREFIX $PYTHON $ABC2LY_PY \
--strict --output=${TARGET} $SOURCE'
ABC = Builder (action = a, suffix = '.ly', src_suffix = '.abc')
env.Append (BUILDERS = {'ABC': ABC})

def add_log_target (target, source, env):
	base = os.path.splitext (str (target[0]))[0]
	return (target + [base + '.log'], source)

def add_enc_ly_tex_target (target, source, env):
	base = os.path.splitext (str (target[0]))[0]
	return (target + [base + '.enc', base + '.tex', base + 'list.ly'],
		source)

def add_suffixes (target, source, env, target_suffixes, src_suffixes):
	base = os.path.splitext (str (target[0]))[0]
	return (target + map (lambda x: base + x, target_suffixes),
		source + map (lambda x: base + x, src_suffixes))

a = 'cd ${TARGET.dir} && \
MFINPUTS=.:${SOURCE.dir}:$srcdir/${SOURCE.dir} \
mf "\\mode:=$MFMODE; nonstopmode; input ${SOURCE.filebase};" \
| grep -v "@\|>>"'
tfm = Builder (action = a, suffix = '.tfm', src_suffix = '.mf',
#	       emitter = lambda t, s, e: add_suffixes (t, s, e, ['.log'], []))
	       emitter = add_log_target)
env.Append (BUILDERS = {'TFM': tfm})

a = '$PYTHON $MF_TO_TABLE_PY \
--outdir=${TARGET.dir} \
--afm=${TARGET.base}.afm \
--enc=${TARGET.base}.enc \
--tex=${TARGET.base}.tex \
--ly=${TARGET.base}list.ly \
${TARGET.base}.log'
afm = Builder (action = a, suffix = '.afm', src_suffix = '.log',
	       emitter = add_enc_ly_tex_target)
env.Append (BUILDERS = {'AFM': afm})

def add_enc_src (target, source, env):
	base = os.path.splitext (str (target[0]))[0]
	return (target, source + [base + '.enc'])

# UGH, should fix --output option for mftrace
a = 'cd ${TARGET.dir} && \
if test -e ${SOURCE.filebase}.enc; then encoding="--encoding=${SOURCE.filebase}.enc"; fi; \
MFINPUTS=$srcdir/mf:.: \
mftrace --pfa --simplify --keep-trying $$encoding $__verbose \
--include=${TARGET.dir} \
${SOURCE.file}'

pfa = Builder (action = a,
	       suffix = '.pfa',
	       src_suffix = '.mf',
	       emitter = add_enc_src)
env.Append (BUILDERS = {'PFA': pfa})

env['DIFF_PY'] = os.path.join (srcdir, 'stepmake/bin/package-diff.py')
a = '$PYTHON $DIFF_PY $__verbose --outdir=${TARGET.dir}'
patch = Builder (action = a, suffix = '.diff', src_suffix = '.tar.gz')
env.Append (BUILDERS = {'PATCH': patch})

def src_glob (env, s):
	here = os.getcwd ()
	os.chdir (env.Dir ('.').srcnode ().abspath)
	result = glob.glob (s)
	os.chdir (here)
	return result
env['src_glob'] = src_glob

def base_glob (env, s):
	return map (lambda x: os.path.splitext (x)[0], src_glob (env, s))
env['glob'] = base_glob

atvars = [
'BASH',
'DATE',
'sharedstatedir',
'GUILE',
'bindir',
'date',
'datadir',
'lilypond_datadir',
'lilypond_libdir',
'local_lilypond_datadir',
'local_lilypond_libdir',
'localedir',
'PACKAGE',
'package',
'PATHSEP',
'PERL',
'prefix',
'program_prefix',
'program_suffix',
'PYTHON',
'SHELL',
'TOPLEVEL_VERSION',
'step-bindir',
]

# naming
def at_copy (target, source, env):
    s = open (str (source[0])).read ()
    for i in atvars:
	    if env.has_key (i):
		    s = string.replace (s, '@%s@'% i, env[i])
    t = str (target[0])
    open (t, 'w').write (s)
    # wugh
    if os.path.basename (os.path.dirname (str (target[0]))) == 'bin':
	    os.chmod (t, 0755)

AT_COPY = Builder (action = at_copy, src_suffix = ['.in', '.py', '.sh',])
env.Append (BUILDERS = {'AT_COPY': AT_COPY})

MO = Builder (action = 'msgfmt -o $TARGET $SOURCE',
	      suffix = '.mo', src_suffix = '.po')
env.Append (BUILDERS = {'MO': MO})

ugh =  'ln -f po/lilypond.pot ${TARGET.dir}/lilypond.po; '
a = ugh + 'xgettext --default-domain=lilypond --join \
--output-dir=${TARGET.dir} --add-comments \
--keyword=_ --keyword=_f --keyword=_i $SOURCES'
PO = Builder (action = a, suffix = '.pot',
	      src_suffix = ['.cc', '.hh', '.py'], multi = 1)
##env.Append (BUILDERS = {'PO': PO})
##env.Command(env['absbuild'] + '/po/' + env['out'] + '/lilypond.pot',
env['potarget'] = os.path.join (env['absbuild'], 'po', env['out'],
				'lilypond.pot')
env['pocommand'] = a

ugh = '; mv ${TARGET} ${SOURCE}'
a = 'msgmerge ${SOURCE} ${SOURCE.dir}/lilypond.pot -o ${TARGET}' + ugh
POMERGE = Builder (action = a, suffix = '.pom', src_suffix = '.po')
env.Append (BUILDERS = {'POMERGE': POMERGE})

a = '$PYTHON $srcdir/buildscripts/bib2html.py -o $TARGET $SOURCE'
BIB2HTML = Builder (action = a, suffix = '.html', src_suffix = '.bib')
env.Append (BUILDERS = {'BIB2HTML': BIB2HTML})

a = '$PYTHON $srcdir/buildscripts/lys-to-tely.py \
--name=${TARGET.base} --title="$TITLE" $SOURCES'
LYS2TELY = Builder (action = a, suffix = '.tely', src_suffix = '.ly')
env.Append (BUILDERS = {'LYS2TELY': LYS2TELY})


def mutopia (ly = None, abc = None):
	if not abc:
		abc = env['glob'] (env, '*.abc')
	if not ly:
		ly = env['glob'] (env, '*.ly') + map (env.ABC, abc)
	pdf = map (env.LilyPond, ly)
	# We need lily and mf to build these.
	env.Depends (pdf, ['#/lily', '#/mf'])
	env.Alias ('doc', pdf)

env['mutopia'] = mutopia


def collate (title = 'collated files'):
	ly = env['glob'] (env, '*.ly')
	e = env.Copy (
		TITLE = title,
		LILYPOND_BOOK_FLAGS = '''--process="lilypond-bin --header=texidoc -I$srcdir/input/test -e '(ly:set-option (quote internal-type-checking) #t)'"''',
													    __verbose = ' --verbose',
													    )
	#		
	tely = e.LYS2TELY ('collated-files', ly)
	texi = e.TEXI (tely)
	# We need lily and mf to build these.
	env.Depends (texi, ['#/lily', '#/mf'])
	dvi = e.Texi2dvi (texi)
	pdf = e.Dvi2pdf (dvi)
	html = e.HTML (texi)

	env.Alias ('doc', pdf)
	env.Alias ('doc', html)

env['collate'] = collate
