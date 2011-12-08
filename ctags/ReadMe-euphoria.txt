ctags is a very old program to extract identifiers from source,
these tags can be used by code editors and support programs to
jump to the file containing the tag or help with completion.

Exuberant Ctags current release version	5.8 as of 2011
get ctags source or binary & source from 
from http://ctags.sourceforge.net
or from their svn repo or an archive of the repo trunk
http://ctags.svn.sourceforge.net/viewvc/ctags/trunk/?view=tar

Euphoria is an opensource rapid development language 
your source can be interpreted or translated and compiled
or simply bound to a backend to produce a standalone executable.

get euphoria 4.1 development or the stable 4.0 release from 
http://openeuphoria.org/wiki/view/DownloadEuphoria.wc
currently would need the struct branch 
if you wanted to run eui -TEST on the test program

version 4 is the stable branch
there is alpha and beta 32 and 64 bit binaries available on eubins
see news, forum and wiki. powered by euphoria!

euphoria is not needed to build or run ctags 
or to run ctags over the test program
or to run ctags for other languages

currently late 2011 you have to compile ctags to get euphoria

there are two regex parsers, simple and callback
copy one of the euphoria.c parsers 
to euphoria.c in the ctags source directory

replace eiffel language in parsers.h 
and in source.mak 2 places with "euphoria".
alternatively, you would have to use the commandline
to force Euphoria or Eiffel if you had both active,
because both languages use the .e file name extension.

build ctags executable using one of the makefiles.
on windows any of the minGW compilers works well.

install or copy the executable to your path
or you can run from the build directory to test
ctags --languages

ran 
path\ctags.exe -f ctags --recurse=yes --exclude="*.b*" --fields=+a+S+n -V * 
on ctags_euphoria_test.e and euphoria.e
to generate ctags-sample

Note: 
	the memtype, memstruct, memunion keywords are from the 
	euphoria 4.1 struct branch and not yet official. the 
	extra parsing will have little to no impact for most projects.
	it would not be too complicated to remove those lines from
	euphoria.c if you find you need the extra speed advantage.
	you can also change the TRUE/FALSE option in kinds to enable/disable

by default the callback euphoria parser collects these kinds of items

n   namespace x and include y as x
m   memtype
s   memstruct
u   memunion
c   constant
t   type
f   function
p   procedure
i   ifdef,elsifdef,define words
l   label target for loop/goto
(later versions may also collect variable declarations)

the simple parser collects these kinds only
 and may miss some declarations the callback would catch

m memtype
s memstruct
u memunion
c constant
t type
p procedure
f function

ctags  --list-kinds=euphoria 
  shows tags for language
to limit the kinds, use commandline something like
 --euphoria-kinds=+p-c for only procedures no constants
 assuming constants were enabled by default and you don't want them.

these options might be changed by default in some ctag parsers

neither parser currently can collect more than the first on the
same line as the constant, type, function or procedure declaration 
 in a multiline list of parameters or constants

public constant x = 0,
  y = 1
-- y is ignored by ctags

function xyz(atom a,
			atom b)
--b is ignored by ctags 


neither euphoria parser really understands euphoria syntax, but, 
running ctags over bad syntax code may cause unpredictable results.
ctags itself is pretty robust and should be fine in any case.

eui -STRICT -TEST prog is one way to check syntax

== How to get ctags working with your editor

PSPad, a little complicated, hots.sourceforge has a solution using
custom javascript and autohotkey scripts built into an installer.
in use there is a Hots system tray icon where you can select ctags
file. only one can be active at a time. when you select an item,
then press the hots key combination, PSPad will jump to the file.
you need absolute paths and line numbers in the ctags file.

many editors have builtin ctags support.

see the ctags documents for how to add ctags support to your editor.

== Bugs & Feature Requests 

please report any bugs or add a feature request for improvements,
including sample code if applicable.

the ctags bug tracker has a patch you may want to apply
there may be no effect on the current euphoria parsers
but, the patch was applied before testing.
as of ctags v5.8 the patch wasn't applied to the official sources or svn.
File Added 	425305: fix-regex-callback-count.patch 	2011-10-05 05:12:19 PDT 
http://sourceforge.net/tracker/?func=detail&aid=3418969&group_id=6556&atid=106556

