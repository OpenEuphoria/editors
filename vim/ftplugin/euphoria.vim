" Vim file type file
" 
" Language:	    Euphoria
" Language Web: http://openeuphoria.org
" Maintainer:	Jeremy Cowgar <jeremy@cowgar.com>
" Last Change:	Thu Nov 11 11:16:31 EST 2010
"

if exists("b:did_ftplugin")
	finish
endif

let b:did_ftplugin = 1

setlocal fo-=t fo+=croql

if &tw == 0
	setlocal tw=95
endif

setlocal commentstring=--%s

" Win32 can filter files in the browse dialog
if has("gui_win32") && !exists("b:browsefilter")
    let b:browsefilter = "Euphoria Source Files (*.e *.ex *.exw)\t*.e;*.ex;*.exw\n" .
	  \ "All Files (*.*)\t*.*\n"
endif

noremap <buffer><silent> ]] m':call search('^\s*\(\(override\\|global\\|public\\|export\)\s\+\)\=\(function\\|procedure\\|type\)', "W")<CR>
noremap <buffer><silent> [[ m':call search('^\s*\(\(override\\|global\\|public\\|export\)\s\+\)\=\(function\\|procedure\\|type\)', "bW")<CR>

