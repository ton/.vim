function! Powerline#Functions#git#GetBranch(symbol) " {{{
    let l:branches = substitute(system('git branch | grep \*'), '\n\|\*', '', 'g')
    return a:symbol . l:branches
endfunction " }}}
