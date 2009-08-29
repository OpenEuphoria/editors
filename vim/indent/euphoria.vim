" Vim indent file
" Language:	Euphoria
" Author:	Jeremy Cowgar <jeremy@cowgar.com>
" Last Change:	2002 Dec 19 10:36 PM 2002 EST
" Version:	0.5
" Notes:  Euphoria: http://www.rapideuphoria.com
"

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
	finish
endif
let b:did_indent = 1

setlocal indentexpr=GetEuphoriaIndent()
setlocal indentkeys+==end,=function,=procedure,=type,=switch,=case,=constant,=enum,=if,=elsif,=else,=for,=while,=entry

" Only define the function once.
if exists("*GetEuphoriaIndent")
	finish
endif

function GetEuphoriaIndent()
	" Find a non-blank line above the current line.
	let lnum = prevnonblank(v:lnum - 1)

	" Hit the start of the file, use zero indent.
	if lnum == 0
		return 0
	endif

	let line  = getline(lnum)    " last line
	let cline = getline(v:lnum) " current line
	let pline = getline(lnum - 1) " previous to last line
	let ind   = indent(lnum)
   
	if line =~ '^\s*\(\(global\|export\|public\|override\)\s*\)*\(function\|procedure\|type\)'
		let ind = ind + &sw
	elseif line =~ '^\s*\(if\|elsif\|else\|for\|while\|case\|entry\)'
		let ind = ind + &sw
	elseif line =~ '^\s*switch'
		let ind = ind + (&sw * 2)
	elseif line =~ '^\s*\(\(global\|export\|public\|override\)\s*\)*\(constant\|enum\).*,$'
		let ind = ind + &sw
	endif

	if cline =~ '^\s*end\s+switch'
		let ind = ind - (&sw * 2)
	elseif cline =~ '^\s*\(end\|else\|elsif\|case\|entry\)'
		let ind = ind - &sw
	endif
	
	return ind
endfunction

" vim: set ts=4 sw=4:

