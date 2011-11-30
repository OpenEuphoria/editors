get ctags source or binary & source from 
from http://ctags.sourceforge.net
or from their svn repo or an archive of the repo trunk
http://ctags.svn.sourceforge.net/viewvc/ctags/trunk/?view=tar


currently late 2011 you have to compile ctags to get euphoria language

there are two regex parsers, simple and callback
copy one of the euphoria.c parsers 
to euphoria.c in the ctags source directory

replace eiffel language in parsers.h 
and in source.mak 2 places with euphoria

build ctags executable using one of the makefiles.
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

by default the callback euphoria parser collects these kinds of items

n namespace  both namespace x and include x as y
i ifdef, elsifdef, with/out define words
m memtype
s memstruct
u memunion
c constant
t type
p procedure
f function

the simple parser collects these kinds only
 and may miss some declarations the callback would catch

m memtype
s memstruct
u memunion
c constant
t type
p procedure
f function

to limit the kinds, use commandline something like
 --euphoria-kinds=+p-c for only procedures no constants
 not sure why you need -c if +p means only procedures though.

these options might be changed by default in some ctag parsers

neither parser currently can collect more than the first on the
same line as the constant, type, function or procedure declaration 
 in a multiline lists of parameters or constants

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


please report any bugs or add a feature request for improvements,
including sample code if applicable.
