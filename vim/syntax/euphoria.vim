" Vim syntax file
" 
" Language:	Euphoria
" Maintainer:	Jeremy Cowgar <jeremy@cowgar.com>
" Last Change:	2009-08-29
"
" Install:
"
" Add something like the following to your ~/.vim/filetype.vim
"
" augroup filetypedetect
"   au! BufRead,BufNewFile *.e, *.ex, *.exw, *.eu, *.exu setfiletype euphoria
" augroup END
" 
" Notes:
" 
" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

" Euphoria Pre-processor words
syn keyword euphoriaPre                elsedef elsifdef ifdef include namespace trace with without

" Euphoria Scope
syn keyword euphoriaScope              export public global override

" Euphoria Keywords
syn keyword euphoriaKeywords	       as and
syn keyword euphoriaKeywords	       break by
syn keyword euphoriaKeywords	       case constant continue
syn keyword euphoriaKeywords	       do
syn keyword euphoriaKeywords	       end else elsif exit entry
syn keyword euphoriaKeywords	       for function
syn keyword euphoriaKeywords	       global goto
syn keyword euphoriaKeywords	       if 
syn keyword euphoriaKeywords           label loop
syn keyword euphoriaKeywords	       not
syn keyword euphoriaKeywords	       or
syn keyword euphoriaKeywords	       procedure
syn keyword euphoriaKeywords	       return retry
syn keyword euphoriaKeywords	       switch
syn keyword euphoriaKeywords	       then type to
syn keyword euphoriaKeywords	       until
syn keyword euphoriaKeywords	       while
syn keyword euphoriaKeywords	       xor

" Types
syn keyword euphoriaTypes	       object sequence integer atom enum

" Constants
syn match euphoriaConstant "\<[A-Z_][A-Z0-9_]*\>"

" Various number methods
syn match euphoriaNumber	"\<[_0-9]\+\>"
syn match euphoriaNumber	"\<[_0-9]\+\.[_0-9]*\>"
syn match euphoriaNumber	"\.[_0-9]\+\>"
syn match euphoriaNumber    "\(#\|0x\)[A-Fa-f0-9_]\+\>"
syn match euphoriaNumber    "\<0b[01]\+\>"
syn match euphoriaNumber    "\<0t[0-7]\+\>"
syn match euphoriaNumber    "\<0d[0-9]\+\>"

" String and Character constants
syn region euphoriaString matchgroup=Normal start=+'+ end=+'+ skip=+\\\\\|\\'+ contains=@Spell
syn region euphoriaString matchgroup=Normal start=+"+ end=+"+ skip=+\\\\\|\\"+ contains=@Spell
syn region euphoriaString matchgroup=Normal start=+`+ end=+`+ contains=@Spell
syn region euphoriaString matchgroup=Normal start=+"""+ end=+"""+ contains=@Spell

" Todo (only highlighted in comments)
syn keyword euphoriaTodo contained	TODO FIXME XXX

syn region euphoriaComment oneline contains=euphoriaTodo,@Spell start="--" end="$"
syn region euphoriaComment contains=euphoriaTodo,@Spell start="/\*" end="\*/"

" Operator
syn match euphoriaOperator   "=\|&\|[!:\[\]\(\)\{\}<>+\*^\\]"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_euphoria_syntax_inits")
	if version < 508
		let did_euphoria_syntax_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif
	
	HiLink euphoriaPre              PreProc
	HiLink euphoriaScope            Special
	HiLink euphoriaKeywords			Keyword
	HiLink euphoriaNumber			Number
	HiLink euphoriaComment			Comment
	HiLink euphoriaConstant         Constant
	HiLink euphoriaString			String
	HiLink euphoriaOperator			Operator
	HiLink euphoriaTypes			Type
	HiLink euphoriaTodo				ToDo
	HiLink euphoriaDocSection       Constant
	
	delcommand HiLink
endif

let b:current_syntax = "euphoria"

" vim: ts=4

