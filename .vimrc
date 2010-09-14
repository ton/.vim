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

" Basic editor settings
set nowrap        			" don't wrap lines
set tabstop=4     			" a tab is four spaces
set backspace=indent,eol,start		" allow backspacing over everything in insert mode
set autoindent    			" always set autoindenting on
set copyindent    			" copy the previous indentation on autoindenting
set number        			" always show line numbers
set shiftwidth=4  			" number of spaces to use for autoindenting
set shiftround    			" use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     			" set show matching parenthesis
set smartcase     			" ignore case if search pattern is all lowercase, case-sensitive otherwise
set smarttab      			" insert tabs on the start of a line according to shiftwidth, not tabstop
set incsearch     			" show search matches as you type

" Quickly edit/reload the vimrc file.
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Read in a custom Vim configuration local to the working directory.
if filereadable(".project.vim")
    so .project.vim
endif

" Enable plugin support based on filetypes.
filetype on
filetype plugin on
filetype indent on

" File type dependent settings.
autocmd filetype python set expandtab

" Highlight trailing whitespace.
highlight TrailingWhitespace ctermbg=red guibg=red
match TrailingWhitespace /\s\+\n$/
