" Vim syntax file
" 
" Language:	    Euphoria
" Language Web: http://openeuphoria.org
" Maintainer:	Jeremy Cowgar <jeremy@cowgar.com>
" Last Change:	Thu Nov 11 11:16:31 EST 2010
"
" Install:
"
" Add something like the following to your ~/.vim/filetype.vim
"
" augroup filetypedetect
"   au! BufRead,BufNewFile *.e, *.ex, *.exw, *.exu setfiletype euphoria
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

" Euphoria Keywords
syn keyword euphoriaKeywords	   and as
syn keyword euphoriaKeywords	   by
syn keyword euphoriaKeywords	   case constant
syn keyword euphoriaKeywords	   do
syn keyword euphoriaKeywords	   else elsif end enum
syn keyword euphoriaKeywords	   for function
syn keyword euphoriaKeywords	   if
syn keyword euphoriaKeywords	   loop
syn keyword euphoriaKeywords	   not
syn keyword euphoriaKeywords	   or
syn keyword euphoriaKeywords	   procedure
syn keyword euphoriaKeywords	   routine
syn keyword euphoriaKeywords	   switch
syn keyword euphoriaKeywords	   then to type
syn keyword euphoriaKeywords	   until
syn keyword euphoriaKeywords	   while
syn keyword euphoriaKeywords	   xor

" Types
syn keyword euphoriaTypes	       object sequence integer atom

" Pre-processor type commands
syn keyword euphoriaPreProc        elsifdef elsedef
syn keyword euphoriaPreProc        ifdef include
syn keyword euphoriaPreProc        namespace
syn keyword euphoriaPreProc        trace
syn keyword euphoriaPreProc        with without

" Branch Jumps
"
" NOTE: abort and crash are routines but are important in jumping (exiting)
" the application so they are included here
"
syn keyword euphoriaJumps          abort
syn keyword euphoriaJumps          break 
syn keyword euphoriaJumps          continue crash
syn keyword euphoriaJumps          entry exit 
syn keyword euphoriaJumps          fallthru
syn keyword euphoriaJumps          goto 
syn keyword euphoriaJumps          label 
syn keyword euphoriaJumps          return retry

" Scope Modifiers
syn keyword euphoriaScope          override global public export

" Namespace use
syn match euphoriaNamespaceUse "\<[A-Za-z0-9_]\+\:"

" integer, number or floating point number without a dot.
syn match euphoriaNumber "\<[0-9_]\+\>"
" floating point number, with dot
syn match  euphoriaNumber "\<[0-9_]\+\.[\d_]*\>"
" floating point number, starting with a dot
syn match  euphoriaNumber "\<\.[0-9_]\+\>"
" binary number
syn match euphoriaNumber "\<0b[0-1_]\+\>"
" octal number
syn match euphoriaNumber "\<0t[0-7_]\+\>"
" decimal number
syn match euphoriaNumber "\<0d[0-9_]\+\>"
" hex number 1
syn match euphoriaNumber "\<0x[0-9A-Fa-f_]\+\>"
" hex number 2
syn match euphoriaNumber "\#[0-9A-Fa-f_]\+\>"

" String and Character constants
syn region  euphoriaString start=+"+  skip=+\\\\\|\\"+  end=+"+ contains=euphoriaEscape,@Spell
syn region  euphoriaString start=+"""+ end=+"""+ contains=@Spell
syn region  euphoriaString start=+`+ end=+`+ contains=@Spell
syn match   euphoriaCharacter "L\='[^\\]'"
syn match   euphoriaCharacter "L'[^']*'" contains=euphoriaEscape

syn match   euphoriaEscape +\\[nrt0eE'"\\]+      contained
syn match   euphoriaEscape +\\b[01]\++           contained
syn match   euphoriaEscape +\\x[0-9A-Fa-f]\{2\}+ contained
syn match   euphoriaEscape +\\u[0-9A-Fa-f]\{4\}+ contained
syn match   euphoriaEscape +\\U[0-9A-Fa-f]\{8\}+ contained

" Operator
syn match   euphoriaOperator   "=\|&\|[!:\[\]\(\)\{\}<>+\*^/\\]"

" Todo (only highlighted in comments)
syn keyword euphoriaTodo contained	TODO FIXME XXX BUG NOTE

syn region euphoriaComment start="/\*" end="\*/" contains=euphoriaTodo,@Spell
syn region euphoriaComment oneline contains=euphoriaTodo start="--" end="$"
syn sync ccomment euphoriaComment

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_euphoria_syntax_inits")
	hi def link euphoriaKeywords        Keyword
	hi def link euphoriaTypes           Type
    hi def link euphoriaPreProc         PreProc
    hi def link euphoriaJumps           Label
    hi def link euphoriaScope           StorageClass
    hi def link euphoriaNamespaceUse    StorageClass
	hi def link euphoriaNumber          Number
	hi def link euphoriaComment         Comment
	hi def link euphoriaString          String
	hi def link euphoriaCharacter       Character
	hi def link euphoriaOperator        Operator
	hi def link euphoriaTodo            ToDo
endif

let b:current_syntax = "euphoria"

" vim: ts=4

