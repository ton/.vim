" Use Vim settings, rather then Vi settings. This must be first, because it
" changes other options as a side effect.
set nocompatible

" Set backup directory.
set backupdir=$HOME/.vim/backup

" Set the swap directory.
set dir=$HOME/.vim/swap

" Switch syntax highlighting and a colorscheme on, when the terminal has colors or when we are
" in GUI mode.
if &t_Co > 2 || has("gui_running")
  colorscheme wombat
  syntax on
else
  colorscheme wombat256
endif

" Load pathogen.
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Set our personal modifier key to ','.
let mapleader = ","

" Quickly edit/reload the vimrc file.
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Read in a custom Vim configuration local to the working directory.
if filereadable(".project.vim")
    so .project.vim
endif
