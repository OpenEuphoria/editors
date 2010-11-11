" Vim syntax file
" 
" Language:     Euphoria eTML
" Maintainer:	Jeremy Cowgar <jeremy@cowgar.com>
" Last Change:	Thu Nov 11 13:02:09 EST 2010
"
" Install:
"
" Add something like the following to your ~/.vim/filetype.vim
"
" augroup filetypedetect
"   au! BufRead,BufNewFile *.etml,*.etag set ft=etml
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

if !exists("main_sytax")
	let main_syntax = 'etml'
endif

if version < 600
	so <sfile>:p:h/html.vim
	syn include @EtmlEuphoria <sfile>:p:h/euphoria.vim
else
	runtime! syntax/html.vim
	unlet b:current_syntax
	syn include @EtmlEuphoria syntax/euphoria.vim
endif

syn cluster htmlPreproc add=EuphoriaInsideHtmlTags

syn region EutagHead start=+{{{+ end=+}}}+
syn region EuphoriaInsideHtmlTags keepend matchgroup=Delimiter start=+<%+ end=+%>+ contains=@EtmlEuphoria

if version >= 508 || !exists("did_etml_syntax_inits")
	hi def link EutagHead Error
endif

let b:current_syntax = "etml"

