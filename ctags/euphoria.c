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
*   m11B28p05:33 ne1 add |public|override.  (mem)*type
*   	it's not ignoring function def inside multiline comments?
*   	next version should be full parser?
*/

/*
*   INCLUDE FILES
*/

#include "general.h"    /* always include first */
#include "parse.h"      /* always include */

/* FUNCTION DEFINITIONS */

static void installEuphoriaRegex (const langType language)
{
	//symbol names can't actually start with numbers, but we let it slide.

    addTagRegex (language,
		"^(global|export|public|override)*[ \t\n]*function[ \t\n]+([a-zA-Z0-9_]+)",
								"\\2", "f,function", NULL);
    addTagRegex (language,
		"^(global|export|public|override)*[ \t\n]*procedure[ \t\n]+([a-zA-Z0-9_]+)",
								"\\2", "p,procedure", NULL);
    addTagRegex (language,
		"^(global|export|public|override)*[ \t\n]*type[ \t\n]+([a-zA-Z0-9_]+)",
								"\\2", "t,type", NULL);

    //memtype might be a list and it would only get the first one 
    addTagRegex (language,
		"^(global|export|public|override)*[ \t\n]*memtype[ \t\n]+([a-zA-Z0-9_]+)[ \t\n]+as[ \t\n]+([a-zA-Z0-9_]+)",
								"\\3", "m,memtype", NULL);

	//memstruct/union/type currently in a branch. not sure ctags can capture them?
    addTagRegex (language,
		"^(global|export|public|override)*[ \t\n]*mem(struct|union)+[ \t\n]+([a-zA-Z0-9_]+)",
								"\\3", "s,mem\\2", NULL);
    //namespace and memtype similar
}

/* Create parser definition stucture */
extern parserDefinition* EuphoriaParser (void)
{
    static const char *const extensions [] = { "e", "ed", "ew", "ex", "exu", "exw", "exd", NULL };
    parserDefinition* const def = parserNew ("Euphoria");
    def->extensions = extensions;
    def->initialize = installEuphoriaRegex;
    def->regex      = TRUE;
    return def;
}
