" Vim syntax file
" Language:	Qt project files

" Case off
syn case ignore

" Variables
" syn match ProVariable   "\${.*}$" contained

" String
syn match  ProString	"\".*\""

" Brackets
" syn keyword ProBracket  ( ) contained

" Comments (Everything before '#' or '//' or ';')
syn match  ProComment	"#.*"
syn match  ProComment	"\/\/.*"
syn region  ProComment	start="\/\*" end="\*\/"

" Variables
syn region ProVariable start="${" end="}" contained

" Define the default hightlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_cfg_syn_inits")
    if version < 508
	let did_cfg_syn_inits = 1
	command -nargs=+ HiLink hi link <args>
    else
	command -nargs=+ HiLink hi def link <args>
    endif
    HiLink ProComment	Comment
    HiLink ProString	String
    HiLink ProVariable  Type

    delcommand HiLink
endif
let b:current_syntax = "cfg"
" vim:ts=8
