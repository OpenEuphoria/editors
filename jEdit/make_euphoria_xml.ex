-- This program creates an XML mode file for jEdit.  It will use the EUDIR environment variable to find the keywords, builtins and standard library routines.  EUDIR must be set to a TRUNK of a development checkout copy.  A standard distributed version (that the installer leaves you) wont allow this program to import the builtin routines.  EUDIR *must* be set.
-- It will look in WXDIR environment variable for the  Euphoria wrapper of the wxWidgets library.  This environment variable is *optional*.
-- It will look in WIN32DIR environment variable for the  Euphoria wrapper of the MSW library.  This environment variable is *optional*.

include euphoria/keywords.e
include std/regex.e as regex
include std/filesys.e as fs
include std/console.e
include std/sequence.e
include std/search.e
include std/text.e

type enum boolean false = 0, true end type

enum KEYWORD, BUILTINS, ROUTINESYM, CONSTANTSYM = ROUTINESYM, NAMESPACE = CONSTANTSYM

constant EUDIR = getenv("EUDIR")
constant WXDIR = getenv("WXDIR")
constant WIN32DIR = getenv("WIN32DIR")

constant namespace_pattern = regex:new( "namespace ([a-zA-Z0-9_]+)" )
constant namespace_pattern__namespace = 2
constant public_symbol_pattern = regex:new( `(global|public)\s+([a-z]+)\s+([a-zA-Z_][A-Za-z0-9_]+)`, regex:DEFAULT)
constant public_symbol_match__public_symbol = 4
constant public_constant_list_pattern = regex:new( `(global|public)\s+((enum)|(constant))\s+([A-Za-z_][A-Za-z0-9_]*)?`, regex:DEFAULT)
constant public_constant_list_pattern__identifier = 6
constant start_euphoria_xml = 
	"<?xml version=\"1.0\"?>\n" &
	"\n" &
	"<!DOCTYPE MODE SYSTEM \"xmode.dtd\">\n" &
	"\n" &
	"<MODE>\n" &
	"\t<PROPS>\n" &
	"\t\t<PROPERTY NAME=\"lineComment\" VALUE=\"--\" />\n" &
	"\t\t<PROPERTY NAME=\"commentStart\" VALUE=\"/*\" />\n" &
	"\t\t<PROPERTY NAME=\"commentEnd\" VALUE=\"*/\" />\n" &
	"\n" &
	"\t</PROPS>\n" &
	"\t<RULES IGNORE_CASE=\"FALSE\" HIGHLIGHT_DIGITS=\"FALSE\">\n" &
	"\t\t<!-- Comment -->\n" &
	"\t\t<EOL_SPAN TYPE=\"COMMENT1\">--</EOL_SPAN>\n" &
	"\t\t\n" &
	"\t\t<SPAN TYPE=\"COMMENT2\" NO_LINE_BREAK=\"FALSE\">\n" &
	"\t\t\t<BEGIN>/*</BEGIN>\n" &
	"\t\t\t<END>*/</END>\n" &
	"\t\t</SPAN>\n" &
	"\t\t\n" &
	"\n" &
	"\t\t<!-- Standard literals -->\n" &
	"\t\t<SPAN TYPE=\"LITERAL1\" NO_LINE_BREAK=\"FALSE\">\n" &
	"\t\t\t<BEGIN>\"\"\"</BEGIN>\n" &
	"\t\t\t<END>\"\"\"</END>\n" &
	"\t\t</SPAN>\n" &
	"\t\t<SPAN TYPE=\"LITERAL1\" ESCAPE=\"\\\" NO_LINE_BREAK=\"FALSE\">\n" &
	"\t\t\t<BEGIN>U\"</BEGIN>\n" &
	"\t\t\t<END>\"</END>\n" &
	"\t\t</SPAN>\n" &
	"\t\t<SPAN TYPE=\"LITERAL1\" ESCAPE=\"\\\" NO_LINE_BREAK=\"FALSE\">\n" &
	"\t\t\t<BEGIN>u\"</BEGIN>\n" &
	"\t\t\t<END>\"</END>\n" &
	"\t\t</SPAN>\n" &
	"\t\t<SPAN TYPE=\"LITERAL1\" ESCAPE=\"\\\" NO_LINE_BREAK=\"FALSE\">\n" &
	"\t\t\t<BEGIN>x\"</BEGIN>\n" &
	"\t\t\t<END>\"</END>\n" &
	"\t\t</SPAN>\n" &
	"\t\t<SPAN TYPE=\"LITERAL1\" ESCAPE=\"\\\" NO_LINE_BREAK=\"TRUE\">\n" &
	"\t\t\t<BEGIN>\"</BEGIN>\n" &
	"\t\t\t<END>\"</END>\n" &
	"\t\t</SPAN>\n" &
	"\t\t<SPAN TYPE=\"LITERAL1\" ESCAPE=\"\\\" NO_LINE_BREAK=\"TRUE\">\n" &
	"\t\t\t<BEGIN>\'</BEGIN>\n" &
	"\t\t\t<END>\'</END>\n" &
	"\t\t</SPAN>\n" &
	"\t\t<SPAN TYPE=\"LITERAL1\" NO_LINE_BREAK=\"FALSE\">\n" &
	"\t\t\t<BEGIN>`</BEGIN>\n" &
	"\t\t\t<END>`</END>\n" &
	"\t\t</SPAN>\t\t\n" &
	"\t\t\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">)</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">(</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">=</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">!=</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">&gt;=</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">&lt;=</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">+</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">-</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">/</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">*</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">&gt;</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">&lt;</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">&amp;</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">|</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">~</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">}</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">{</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">,</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">]</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">[</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">?</SEQ>\n" &
	"\t\t<SEQ TYPE=\"OPERATOR\">:</SEQ>\n" &
	"\n" &
	""
	
if atom(EUDIR) then
	maybe_any_key("EUDIR not set... cannot continue.\n")
	abort(1)
end if

integer out = open("new-euphoria.xml","w")
puts(out, start_euphoria_xml)
puts(out, "\t\t<KEYWORDS>\n")

puts(out, "\t\t\t<!-- Keywords -->\n")
for keyword_i = 1 to length(keywords) do
	printf(out, "\t\t\t<KEYWORD%d>%s</KEYWORD%d>\n", KEYWORD & keywords[keyword_i..keyword_i] & KEYWORD)
end for
procedure grab_builtins()
	puts(out, "\t\t\t<!-- Builtin Routines -->\n")
	integer inf = open(EUDIR & "/docs/builtins.txt", "r" )
	object line
	while sequence(line) entry do
		sequence match_patterns = regex:find_all( regex:new( `\[\[:([a-z0-9_]+)\]\]`, regex:DEFAULT), line )
		for match_i = 1 to length(match_patterns) do
			sequence match_pattern = match_patterns[match_i][2]
			
			printf(out, "\t\t\t<KEYWORD%d>%s</KEYWORD%d>\n", BUILTINS  & {slice( line, match_pattern[1], match_pattern[2])} & BUILTINS)		
		end for
	entry
		line = gets(inf)
	end while
	close(inf)
end procedure
grab_builtins()

constant enum_or_constant_entry_pattern = regex:new( `\s*([a-z_0-9A-Z]+).*,\s*` )
constant enum_or_constant_entry_match_pattern__id = 2
function keyword_symbols( sequence path, sequence fs_entry )
	integer constant_or_enum_list = 0
	if find('d', fs_entry[fs:D_ATTRIBUTES] ) then
		return 0
	end if
	if not ends(".e", lower(fs_entry[D_NAME])) and not ends(".ew", lower(fs_entry[D_NAME])) then
		return 0
	end if
	integer inf = open( path & "/" & fs_entry[D_NAME], "r" )
	object line
	while sequence(line) entry do
		if constant_or_enum_list then
			object enum_or_constant_entry_match = regex:matches( enum_or_constant_entry_pattern, line )
			if atom(enum_or_constant_entry_match) then
				constant_or_enum_list = false
			else
				-- constant
				printf(out,"\t\t\t<KEYWORD%d>%s</KEYWORD%d>\n", {CONSTANTSYM, enum_or_constant_entry_match[enum_or_constant_entry_match_pattern__id], CONSTANTSYM})
			end if	
		else
			object public_symbol_match = regex:matches( public_symbol_pattern, line )
			if sequence(public_symbol_match) then
				public_symbol_match = public_symbol_match[public_symbol_match__public_symbol]
			end if
			object namespace_matches = regex:matches( namespace_pattern, line )
			if not atom(public_symbol_match) and not find(public_symbol_match,keywords) then
				printf(out, "\t\t\t<KEYWORD%d>%s</KEYWORD%d>\n", {ROUTINESYM,public_symbol_match,ROUTINESYM})
			elsif sequence(namespace_matches) then
				printf(out, "\t\t\t<KEYWORD%d>%s</KEYWORD%d>\n", {NAMESPACE, namespace_matches[namespace_pattern__namespace], NAMESPACE} )
			else
				object public_constant_list_match = regex:matches(public_constant_list_pattern, line )
				if sequence(public_constant_list_match) then
					constant_or_enum_list = true
					if length(public_constant_list_match) = public_constant_list_pattern__identifier
						and sequence(public_constant_list_match[public_constant_list_pattern__identifier]) then				
						printf(out,"\t\t\t<KEYWORD%d>%s</KEYWORD%d>\n", {CONSTANTSYM,public_constant_list_match[public_constant_list_pattern__identifier],CONSTANTSYM})
					end if
				end if
			end if
		end if
	entry
		line = gets(inf)
	end while
	close(inf)
	return 0
end function

puts(out, "\t\t\t<!-- Standard Library Symbols -->\n")
if ( walk_dir( EUDIR & "/include/std", routine_id("keyword_symbols"), 1 ) = 0 ) then
	puts(1, "Imported Standard Library Symbols into Jedit's mode file.\n")
end if
puts(out, "\t\t\t<!-- Internal EUPHORIA Symbols -->\n")
if ( walk_dir( EUDIR & "/include/euphoria", routine_id("keyword_symbols"), 1 ) = 0 ) then
	puts(1, "Imported Internal Euphoria Library Symbols into Jedit's mode file.\n")
end if

object wxWidgets_location
if atom(WXDIR) then
	wxWidgets_location = console:prompt_string("Please enter the wxWidgets directory location [just ENTER to not import]:")
else
	wxWidgets_location = WXDIR
end if
if file_exists( wxWidgets_location ) then
	puts(out, "\t\t\t<!-- WxWidgets Library Symbols -->\n")
	if walk_dir( wxWidgets_location, routine_id("keyword_symbols"), 1 ) = 0 then  
		puts(1, "Imported WxWidgets Library Symbols into Jedit's mode file.\n")
	end if
end if
object win32dir_location
if atom(WIN32DIR) then
	win32dir_location = console:prompt_string("Please enter the win32lib directory location [just ENTER to skip]:")
else
	win32dir_location = WIN32DIR
end if
if file_exists(win32dir_location) then
	puts(out, "\t\t\t<!-- win32lib Library Symbols -->\n")
	if walk_dir( win32dir_location & "/Include", routine_id("keyword_symbols"), 1 ) = 0 then
		puts(1, "Imported win32lib Library Symbols into Jedit's mode file.\n")
	end if
end if


puts(out, "\t\t</KEYWORDS>\n")
puts(out, "\t</RULES>\n")
puts(out, "</MODE>\n")
close(out)
