if exists("b:did_ftplugin")
	finish
endif

let b:did_ftplugin = 1

setlocal fo-=t fo+=croql

if &tw == 0
	setlocal tw=95
endif

setlocal commentstring=--%s

noremap <silent><buffer> [[ m':call search('^\s*\(\(global\|export\|public\|override\)\s*\)*\(function\|procedure\|type\)', "bW")<CR>
noremap <silent><buffer> ]] m':call search('^\s*\(\(global\|export\|public\|override\)\s*\)*\(function\|procedure\|type\)', "W")<CR>

