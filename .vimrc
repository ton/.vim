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
set wrap                            " wrap too long lines.
set tabstop=4                       " a tab is four spaces
set backspace=indent,eol,start      " allow backspacing over everything in insert mode
set autoindent                      " always set autoindenting on
set copyindent                      " copy the previous indentation on autoindenting
set number                          " always show line numbers
set shiftwidth=4                    " number of spaces to use for autoindenting
set shiftround                      " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch                       " set show matching parenthesis
set smartcase                       " ignore case if search pattern is all lowercase, case-sensitive otherwise
set smarttab                        " insert tabs on the start of a line according to shiftwidth, not tabstop
set incsearch                       " show search matches as you type
set autoread                        " automatically reload a file when it has been changed
set printoptions=paper:a4,duplex:on " print on a4 by default and enable duplex printing
set expandtab                       " insert spaces when the tab key is pressed
set hidden                          " be able to put the current buffer to the background without writing to disk and remember marks and undo-history when a background buffer becomes current again
set showmatch                       " enable brace highlighting
set matchtime=3                     " set brace match time
set history=50                      " keep 50 lines of command line history
set ruler                           " show the cursor position all the time
set showcmd                         " display incomplete commands
set scrolloff=3                     " maintain more context around the cursor

" Quickly edit/reload the vimrc file.
nmap <silent> <leader>ov :e $MYVIMRC<CR>
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

" Highlight all trailing whitespace, instead of trailing whitespace followed
" by the cursor.
highlight TrailingWhitespace ctermbg=red guibg=red
match TrailingWhitespace /\s\+\%#\@!\n/

" ------------------------------------------------------------------------------------------------------------------------
" Custom key mappings.
" ------------------------------------------------------------------------------------------------------------------------

" Remap Ctrl-j and Ctrl-k to allow for easy tab switching.
nmap <silent> <C-j> :tabp<CR>
nmap <silent> <C-k> :tabn<CR>

" Remap Ctrl-s to save the current file.
map <silent> <C-s> :w<CR>
imap <silent> <C-s> <Esc>:w<CR>a

" Remap Ctrl-Q to close the current buffer.
map <silent> <C-q> :bunload<CR>

" ------------------------------------------------------------------------------------------------------------------------
" Configure plugins.
" ------------------------------------------------------------------------------------------------------------------------

" Configure Command-T plugin.
function! CommandTOpenInNewTab()
    let g:CommandTAcceptSelectionMap = ""
    let g:CommandTAcceptSelectionTabMap = "<CR>"
    exe "CommandT"
endfunction

function! CommandTOpenInCurrentTab()
    let g:CommandTAcceptSelectionMap = "<CR>"
    let g:CommandTAcceptSelectionTabMap = ""
    exe "CommandT"
endfunction

let g:CommandTMatchWindowAtTop = 1                  " show the Command-T popup at the top of the screen
let g:CommandTMaxHeight = 20                        " maximum height of Command-T popup
nmap <silent> <leader>e :call CommandTOpenInCurrentTab()<CR>
nmap <silent> <leader>t :call CommandTOpenInNewTab()<CR>
nmap <silent> <leader>r :CommandTFlush<CR>

" Configure bufsurf plugin.
nmap <silent> <C-i> :BufSurfBack<CR>
nmap <silent> <C-o> :BufSurfForward<CR>

" Configure bufexplorer plugin.
let g:bufExplorerShowRelativePath = 1               " show relative paths
map <silent> <leader>b :BufExplorer<CR>             " map <leader>b to opening to buffer explorer
