/*
*   $Id$
*
*   Copyright (c) 2008 by Jeremy Cowgar
*
*   This source code is released for free distribution under the terms of the
*   GNU General Public License.
*
*   This module contains functions for generating tags for Euphoria routines.
*   http://openeuphoria.org/
*
*   m11B28p05:33 ne1 add |public|override.  (mem)*type, constant
*   	it's not ignoring function def inside multiline comments?
*   	will not collect items from a list
*   	multiline function sig is not collected
*   	everything after mem* or constant is captured
*   	next version should be full parser.
*  t11B29p02:00 can callback regex handle multiline?
*   	this may still fail for public\nitem(\n) to get function sig
*   	really not much different than the simple parser so far
*   	added collect namespace & ifdef, elsifdef, define words
*   	may want to get define but not ifdef/elsifdef?
*   	output a little weird for the include lines and slashes
*   	tag parser still needs to be implemented
*/

/*
*   INCLUDE FILES
*/

#include "general.h"    /* always include first */
#include "parse.h"      /* always include */
#include "read.h"
#include "vstring.h"

/* DATA DEFINITIONS */


static kindOption EuphoriaKinds [] = {
	{ TRUE, 'n', "namespace", " namespace x or include y as x" },
	{ TRUE, 'm', "memtype", " memtype" },
	{ TRUE, 's', "memstruct", " memstruct" },
	{ TRUE, 'u', "memunion", " memunion" },
	{ TRUE, 'c', "constant", " constant" },
	{ TRUE, 't', "type", " type" },
	{ TRUE, 'f', "function", " function" },
	{ TRUE, 'p', "procedure", " procedure" },
	{ TRUE, 'i', "ifelsedefs", " ifdef,elsifdef,define words" },
	{ TRUE, 'l', "label ", " label target for loop/goto" }
};

typedef enum {
	knamespace=0,
	kmemtype,
	kmemstruct,
	kmemunion,
	kconstant,
	ktype,
	kfunction,
	kprocedure,
	kifelsedef,
	klabel
 } EuphoriaKind;
/* FUNCTION DEFINITIONS */

static void defMemType (const char *const line, const regexMatch *const matches,
						const unsigned int count)
{
	if (count > 2)    /* should always be true per regex */
	{
		vString *const name = vStringNew ();
		vStringNCopyS (name, line + matches [3].start, matches [3].length);
		makeSimpleTag (name, EuphoriaKinds, kmemtype);
	}
}


static void defMemStruct (const char *const line, const regexMatch *const matches,
						const unsigned int count)
{
	if (count > 2)    /* should always be true per regex */
	{
		vString *const name = vStringNew ();
		vStringNCopyS (name, line + matches [3].start, matches [3].length);

		//chk is struct/union
		if ( *(line + matches [2].start) == 'u'){
			makeSimpleTag (name, EuphoriaKinds, kmemunion);
		} else {
			makeSimpleTag (name, EuphoriaKinds, kmemstruct);
		}
	}
}


static void defFunDef (const char *const line, const regexMatch *const matches,
						const unsigned int count)
{
	if (count > 2)    /* should always be true per regex */
	{
		vString *const name = vStringNew ();
		vStringNCopyS (name, line + matches [3].start, matches [3].length);
		//chk is fun/pro
		if ( *(line + matches [2].start) == 'f'){
			makeSimpleTag (name, EuphoriaKinds, kfunction);
		} else {
			makeSimpleTag (name, EuphoriaKinds, kprocedure);
		}
	}
}

static void defType (const char *const line, const regexMatch *const matches,
						const unsigned int count)
{
	if (count > 1)    /* should always be true per regex */
	{
		vString *const name = vStringNew ();
		vStringNCopyS (name, line + matches [2].start, matches [2].length);
		makeSimpleTag (name, EuphoriaKinds, ktype);
	}
}


static void defConst (const char *const line, const regexMatch *const matches,
						const unsigned int count)
{
	if (count > 1)    /* should always be true per regex */
	{
		vString *const name = vStringNew ();
		vStringNCopyS (name, line + matches [2].start, matches [2].length);
		makeSimpleTag (name, EuphoriaKinds, kconstant);
	}
}


static void defNs (const char *const line, const regexMatch *const matches,
						const unsigned int count)
{
	if (count > 1 )    /* should always be true per regex */
	{
		vString *const name = vStringNew ();
		//this will need work to distinguish namespace x from as x
		//namespace x should be count=4, 
		//y as x should be x=count=$
		// include y as x should be x=$
		vStringNCopyS (name, line + matches [count-1].start, matches [count-1].length);
		makeSimpleTag (name, EuphoriaKinds, knamespace);
	}
}



static void defIfDef (const char *const line, const regexMatch *const matches,
						const unsigned int count)
{
	if (count > 1)    /* should always be true per regex */
	{
		vString *const name = vStringNew ();
		//later may want to distinguish ifdef,elsifdef, with/out  define 
		vStringNCopyS (name, line + matches [count-1].start, matches [count-1].length);
		makeSimpleTag (name, EuphoriaKinds, kifelsedef);
	}
}

static void defLabel (const char *const line, const regexMatch *const matches,
						const unsigned int count)
{
	if (count > 1 )    /* should always be true per regex */
	{
		vString *const name = vStringNew ();
		vStringNCopyS (name, line + matches [count-1].start, matches [count-1].length);

		// would like to prepend label to the found expression
		// label goto "whatever" instead of goto "whatever" 
		// displayed after the filename in the default output
		// name at this point only has whatever
		// not sure how to access the expression w/o a parser

		makeSimpleTag (name, EuphoriaKinds, klabel);
	}
}

static void findEuphoriaTags (void)
{
	while (fileReadLine () != NULL)
		;  /* don't need to do anything here since callback is sufficient */
}


/* FUNCTION DEFINITIONS */

static void installEuphoriaRegex (const langType language)
{
	//is there any sense to rearranging these for most frequent hit order?
	//symbol names can't actually start with numbers, but we let it slide.

	addCallbackRegex (language,
			"^[ \t\n]*(global|export|public|override)*[ \t\n]*(procedure|function)+[ \t\n]+([a-zA-Z0-9_]+)",
				NULL, defFunDef);

	addCallbackRegex (language,
			"^[ \t\n]*(global|export|public|override)*[ \t\n]*type[ \t\n]+([a-zA-Z0-9_]+)",
				NULL, defType);

	//will miss some, regx parser can't collect from list
	addCallbackRegex (language,
			"^[ \t\n]*(global|export|public|override)*[ \t\n]*constant[ \t\n,]+([a-zA-Z0-9_]+)",
				NULL, defConst);

	//memstruct/union/type currently in a branch. 
	// this won't affect parsing std euphoria
	addCallbackRegex (language,
			"^[ \t\n]*(global|export|public|override)*[ \t\n]*mem(struct|union)+[ \t\n]+([a-zA-Z0-9_]+)",
				NULL, defMemStruct);

	//memtype might be a list and it would only get the first one
	addCallbackRegex (language,
			"^[ \t\n]*(global|export|public|override)*[ \t\n]*memtype[ \t\n]+([a-zA-Z0-9_]+)[ \t\n]+as[ \t\n]+([a-zA-Z0-9_]+)",
				NULL, defMemType);

	//namespace x vrs include y as x
	//could miss some hypothetical namespace called aswhatever?
	addCallbackRegex (language,
			"^[ \t\n]*(public)*[ \t\n]*(include|namespace)+[ \t\n]+([a-zA-Z0-9\\/~#:\"._-]+)[ \t\n]*(as)*[ \t\n]*([a-zA-Z0-9_]*)",
				NULL, defNs);

	addCallbackRegex (language,
			"^[ \t\n]*(ifdef|elsifdef|with|without)+[ \t\n]+(not|define)*[ \t\n]*([a-zA-Z0-9_]+)",
				NULL, defIfDef);

	addCallbackRegex (language,
			//add for/while/etc targets, is /s required after keyword?
			"^[ \t\n]*(label|goto|continue|exit)+[ \t\n]+\"([^\"]+)",  //\"
				NULL, defLabel);
}

/* Create parser definition stucture */
extern parserDefinition* EuphoriaParser (void)
{
	static const char *const extensions [] = { "e", "ed", "ew", "ex", "exu", "exw", "exd", NULL };
	parserDefinition* const def = parserNew ("Euphoria");
	def->initialize = installEuphoriaRegex;
	def->kinds      = EuphoriaKinds;
	def->kindCount  = KIND_COUNT (EuphoriaKinds);
	def->extensions = extensions;
	def->parser     = findEuphoriaTags;
	return def;
}
