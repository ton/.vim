" Use Vim settings, rather then Vi settings. This must be first, because it
" changes other options as a side effect.
set nocompatible

" Enable 256 colors for gnome-terminal.
if $COLORTERM == 'gnome-terminal' || $COLORTERM == 'rxvt' || $COLORTERM == 'rxvt-xpm'
    set t_Co=256
endif

" Switch syntax highlighting and a colorscheme on, when the terminal has colors or when we are
" in GUI mode.
if has("gui_running")
    colorscheme wombat
    syntax on
elseif &t_Co > 2
    set t_so=[7m
    set t_ZH=[3m
    colorscheme wombat256
    syntax on
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
set number                          " always show line numbers
set numberwidth=5                   " we are good for up to 99999 lines
set shiftwidth=4                    " number of spaces to use for autoindenting
set shiftround                      " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch                       " set show matching parenthesis
set smartcase                       " ignore case if search pattern is all lowercase, case-sensitive otherwise
set smarttab                        " insert tabs on the start of a line according to shiftwidth, not tabstop
set incsearch                       " show search matches as you type
set autoread                        " automatically reload a file when it has been changed
set printoptions=paper:a4,duplex:on " print on a4 by default and enable duplex printing
set expandtab                       " insert spaces when the tab key is pressed
set hidden                          " be able to put the current buffer to the background without writing to disk and remember marks and
                                    " undo-history when a background buffer becomes current again
set showmatch                       " enable brace highlighting
set matchtime=3                     " set brace match time
set history=50                      " keep 50 lines of command line history
set ruler                           " show the cursor position all the time
set showcmd                         " display incomplete commands
set scrolloff=3                     " maintain more context around the cursor
set pastetoggle=<F2>                " F2 temporarily disables formatting when pasting text
set listchars=tab:▸\ ,trail:·       " Set custom characters for non-printable characters
set textwidth=150                   " Default text width
set colorcolumn=+1                  " Display a one column wide right gutter
set undofile                        " Enable persistent undo
set undodir=$HOME/.vim/undo         " Set the persistent undo directory
set backupdir=$HOME/.vim/backup     " Set the backup directory
set dir=$HOME/.vim/swap             " Set the swap directory
set clipboard=unnamedplus           " Use the system clipboard by default

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

" Always start editing a file in case a swap file exists.
augroup SimultaneousEdits
    autocmd!
    autocmd  SwapExists * :let v:swapchoice = 'e'
augroup End

" -----------------------------------------------------------------------------------------------------------------------------------------------
" Custom key mappings.
" -----------------------------------------------------------------------------------------------------------------------------------------------
function! Make()
  exe "wa"
  exe "mak"
  exe "cw"
  call feedkeys("<CR>", "n")
  call feedkeys("<CR>", "n")
endfunction

" Map Alt-n to switch to the n-th tab.
nmap <A-1> :tabnext 1<CR>
nmap <A-2> :tabnext 2<CR>
nmap <A-3> :tabnext 3<CR>
nmap <A-4> :tabnext 4<CR>
nmap <A-5> :tabnext 5<CR>

" Remap Ctrl-s to save the current file.
map <silent> <C-s> :w<CR>
imap <silent> <C-s> <Esc>:w<CR>a

" Remap Ctrl-q to close the current buffer.
nmap <silent> <C-q> :bdelete<CR>

" Remap ,m to make.
nmap <silent> <leader>m :silent! call Make()<CR>:redraw!<CR>

" Remap Ctrl-j and Ctrl-k to jump to next and previous compiler error.
nmap <silent> <C-k> :cp<CR>
nmap <silent> <C-j> :cn<CR>

" -----------------------------------------------------------------------------------------------------------------------------------------------
" Configure plugins.
" -----------------------------------------------------------------------------------------------------------------------------------------------

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
let g:CommandTCancelMap = '<ESC>'                   " dismiss the Command-T popup

nmap <silent> <leader>e :call CommandTOpenInCurrentTab()<CR>
nmap <silent> <leader>t :call CommandTOpenInNewTab()<CR>
nmap <silent> <leader>r :CommandTFlush<CR>

" Configure bufsurf plugin.
nmap <silent> <C-i> :BufSurfBack<CR>
nmap <silent> <C-o> :BufSurfForward<CR>
let g:BufSurfIgnore = '\[BufExplorer\],GoToFile'

" Configure bufexplorer plugin.
let g:bufExplorerFindActive = 0                     " prevent BufExplorer from messing up the navigation history
let g:bufExplorerShowRelativePath = 1               " show relative paths
map <silent> <leader>b :BufExplorer<CR>             " map <leader>b to opening to buffer explorer

" Configure a.vim.
map <F4> :A<CR>                                     " switch between header and implementation using F4

" -----------------------------------------------------------------------------------------------------------------------------------------------
" Configure (keyword) completion.
" -----------------------------------------------------------------------------------------------------------------------------------------------
function! OmniPopup(action)
    if pumvisible()
        if a:action == "down"
            return "\<C-N>"
        elseif a:action == "up"
            return "\<C-P>"
        endif
    endif
    return a:action
endfunction

" Remap Ctrl-j and Ctrl-k to move up and down in popup lists.
inoremap <silent> <C-j> <C-R>=OmniPopup("down")<CR>
inoremap <silent> <C-k> <C-R>=OmniPopup("up")<CR>

" Open the completion menu using C-Space, note that C-Space inserts the <Nul> character.
inoremap <silent> <expr> <Nul> pumvisible() ? "" : "\<C-X>\<C-U>\<Down>"

" Escape should always close the completion menu at once.
inoremap <silent> <expr> <Esc> pumvisible() ? "\<C-E>\<Esc>" : "\<Esc>"

" Enter should select the currently highlighted menu item.
inoremap <silent> <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"

" Configure (keyword) completion.
set completeopt=longest,menuone

" Use clang library for C++ keyword completion, which is faster and boasts more features.
let g:clang_auto_select = 1
let g:clang_library_path = '/usr/local/lib/'
let g:clang_use_library = 1

" -----------------------------------------------------------------------------------------------------------------------------------------------
" File type specific settings.
" -----------------------------------------------------------------------------------------------------------------------------------------------

" Automatically remove trailing whitespace before write.
function! StripTrailingWhitespace()
    normal mZ
    %s/\s\+$//e
    if line("'Z") != line(".")
        echo "Stripped whitespace\n"
    endif
    normal `Z
endfunction

" Syntax highlighting for Qt qmake project files.
au BufEnter *.pro setlocal syntax=pro

" Syntax highlighting for Go.
au BufEnter *.go setlocal syntax=go

" Set tab stop to 1 for Qt UI definition files.
au BufEnter *.ui setlocal tabstop=1
au BufEnter *.ui setlocal shiftwidth=1

" Show cursor column for source files.
au BufEnter *.c,*.cpp,*.h,*.php,*.py setlocal colorcolumn=+1

" Strip trailing white spaces in source code.
au BufWritePre .vimrc,*.js,*.cpp,*.hpp,*.php,*.h,*.c :call StripTrailingWhitespace()

" Do not expand tabs for web related source code.
au BufEnter *.php,*.html,*.css,*.js setlocal noexpandtab

" Show special characters in source code.
au BufEnter *.php,*.html,*.css,*.cpp,*.h,*.js,*.py setlocal list

" Set text width for Git commit messages.
au BufEnter .git/COMMIT_EDITMSG setlocal textwidth=72

" May solve slow PHP performance
" autocmd BufWinLeave * call clearmatches()
