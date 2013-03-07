"-------------------------------------------------------------------------------
" Text formatting
"-------------------------------------------------------------------------------

set autoindent                       " always set autoindenting on
set expandtab                        " insert spaces when the tab key is pressed
set shiftround                       " use multiple of shiftwidth when indenting
                                     " with '<' and '>'
set shiftwidth=4                     " number of spaces to use for autoindenting
set smarttab                         " insert tabs on the start of a line
                                     " according to shiftwidth, not tabstop
set tabstop=4                        " a tab is four spaces
set wrap                             " wrap overlong lines

"-------------------------------------------------------------------------------
" UI settings
"-------------------------------------------------------------------------------

syntax on                            " enable syntax highlighting
colorscheme wombat256                " set colorscheme for 256 color terminals

set t_so=[7m                       " set escape codes for standout mode
set t_ZH=[3m                       " set escape codes for italics mode
set t_Co=256                         " force 256 colors by default

set backspace=indent,eol,start       " allow backspacing over everything in
                                     " insert mode
set nofoldenable                     " disable code folding by default
set number                           " always show line numbers
set numberwidth=5                    " we are good for up to 99999 lines
set ruler                            " show the cursor position all the time
set showcmd                          " display incomplete commands
set mouse=a                          " allow for mouse scrolling in tmux

" Enable Doxygen syntax highlighting.
let g:load_doxygen_syntax=1
let g:doxygen_javadoc_autobrief=0

" Use custom colors for Doxygen syntax highlighting.
highlight link doxygenBrief Comment
highlight link doxygenSpecialOneLineDesc Comment
highlight link doxygenSpecialTypeOneLineDesc Comment

highlight SpecialComment cterm=NONE ctermfg=240
highlight link doxygenSpecial SpecialComment
highlight link doxygenBOther SpecialComment
highlight link doxygenSmallSpecial SpecialComment
highlight link doxygenParamDirection SpecialComment

highlight doxygenParamName cterm=bold ctermfg=249
highlight link doxygenArgumentWord doxygenParamName
highlight link doxygenCodeWord doxygenParamName

" Resize splits when the window is resized.
au VimResized * exe "normal! \<c-w>="

"-------------------------------------------------------------------------------
" Visual cues
"-------------------------------------------------------------------------------

set incsearch                        " show search matches as you type
set listchars=tab:▸\ ,trail:·        " set custom characters for non-printable
                                     " characters
set list                             " always show non-printable characters
set matchtime=3                      " set brace match time
set scrolloff=3                      " maintain more context around the cursor
set linebreak                        " wrap lines at logical word boundaries
set showbreak=↪                      " character to display in front of wrapper
                                     " lines
set showmatch                        " enable brace highlighting
set smartcase                        " ignore case if search pattern is all
                                     " lowercase, case-sensitive otherwise
set visualbell                       " only show a visual cue when an error
                                     " occurs
set laststatus=2                     " always show the status line

"-------------------------------------------------------------------------------
" Behavioural settings
"-------------------------------------------------------------------------------

set autoread                         " automatically reload a file when it has
                                     " been changed
set backup                           " enable backups
set backupdir=$HOME/.vim/backup      " set the backup directory
set undofile                         " enable persistent undo
set undodir=$HOME/.vim/undo          " persistent undo directory
set clipboard=unnamedplus            " use the system clipboard by default
set dir=$HOME/.vim/swap              " set the swap directory
set hidden                           " be able to put the current buffer to the
                                     " background without writing to disk and
                                     " remember marks and undo-history when a
                                     " background buffer becomes current again
set history=50                       " keep 50 lines of command line history
set printoptions=paper:a4,duplex:on  " print on a4 by default and enable duplex
                                     " printing
set nostartofline                    " do not change the X position of the
                                     " cursor when paging up and down

"-------------------------------------------------------------------------------
" Key remappings
"-------------------------------------------------------------------------------

" Leader + 2 toggles between paste modes.
nmap <silent> <leader>2 :set paste!<CR>

" Map Ctrl-BackSpace to delete the previous word. Since URxvt maps
" Ctrl-BackSpace to ^[^?, we need to specify that key combination here as well.
imap <Esc><BS> <C-W>

" Quickly edit and reload the vimrc file.
nmap <silent> <leader>ov :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Map Y to copy to the end of the line (which is more logical, also according
" to the Vim manual).
map Y y$

" Remap Ctrl-s to save the current file.
map <silent> <C-s> :w<CR>
imap <silent> <C-s> <Esc>:w<CR>a

" Switch Ctri-i and Ctrl-o, jumping backwards using Ctrl-i and forwards using
" Ctrl-o seems more logical given the keyboard layout.
nnoremap <C-i> <C-o>
nnoremap <C-o> <C-i>

" Remap Ctrl-q to close the current buffer
nmap <silent> <C-q> :bw!<CR>

" Remap K to do nothing instead of searching the man pages.
nnoremap K <nop>

" Remap Q to do nothing instead of entering ex mode.
nnoremap Q <nop>

" Remap <leader>m to execute a make.
function! Make()
    exe "wa"
    exe ""
    call Build(&makeprg)
    " exe "mak"
    " exe "cw"
    "call feedkeys("<CR>", "n")
    "call feedkeys("<CR>", "n")
endfunction

" Runs the given command, and in case the command is succesfull, closes the
" tmux pane, otherwise, it leaves the tmux pane open for analysis.
function! VimuxRunCommandOnce(command)
    call VimuxRunCommand(a:command . "; if [ $? == 0 ]; then vim --servername " . v:servername . " --remote-send \"<Esc>:call VimuxClosePanes()<CR>\"; fi")
endfunction

" Runs the user-specified make command, and opens the quickfix window in case
" there are any errors.
function! VimuxMake()
    exe "ccl"
    call VimuxRunCommand(&makeprg . " 2>&1 | tee /tmp/errors.err; vim --servername " . v:servername . " --remote-send '<Esc>:cfile /tmp/errors.err | cw<CR><CR>'")
endfunction

nmap <silent> <leader>m :silent! call VimuxMake()<CR>

" Remap Ctrl-k and Ctrl-j to jump to the previous and next compiler error
" respectively.
nmap <silent> <C-k> :cp<CR>
nmap <silent> <C-j> :cn<CR>

" Map ^ to grep word under cursor using Ack.
nmap ^ :Ack<CR><CR>

" Use the silver searcher by default for the Ack plugin (we need a clean and
" simple separate Ag plugin :P).
let g:ackprg = 'ag --nogroup --nocolor --column'

"-------------------------------------------------------------------------------
" Configure plugins
"-------------------------------------------------------------------------------

" Load pathogen.
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Enable plugin support based on filetypes.
filetype on
filetype plugin on
filetype indent on

" Configure Command-T plugin.
function! CommandTOpenInCurrentTab()
    let g:CommandTAcceptSelectionMap = "<CR>"
    let g:CommandTAcceptSelectionTabMap = ""
    exe "CommandT"
endfunction

" Improve highlighting of matching characters in Command-T's popup window.
highlight default link CommandTCharMatched Question

" Show the Command-T popup at the top of the screen with a maximum height of 20
" lines.
let g:CommandTMatchWindowReverse = 1
let g:CommandTMaxHeight = 10

" Use Escape to dismiss the Command-T popup menu.
let g:CommandTCancelMap = '<ESC>'

" Use MRU ordering for buffer list in Command-T.
let g:CommandTUseMruBufferOrder = 1

" Use <leader>e to open the Command-T popup menu, and <leader>r to refresh the
" Command-T cached.
nmap <silent> <leader>e :call CommandTOpenInCurrentTab()<CR>
nmap <silent> <leader>r :CommandTFlush<CR>
nmap <silent> <leader>b :CommandTBuffer<CR>

" Switch between header and implementation using F4.
map <F4> :A<CR>

" Configure the search paths to look for include/source files, and never open a
" non existing source file.
let g:alternateSearchPath = 'sfr:../source,sfr:../src,sfr:../include,sfr:../inc,sfr:../itf'
let g:alternateNoDefaultAlternate = 1

" Configure the YankRing plugin. Note that we remove Y from the list of
" YankRing keys for normal mode to make sure that the remap for Y from earlier
" actually works.
let g:yankring_history_dir = expand('$HOME/.vim/')
let g:yankring_n_keys = 'D x X'

" Configure the height of the Vimux split pane as a percentage of the total
" screen height.
let g:VimuxHeight = "15"
let g:VimuxUseNearestPane = 1

"-------------------------------------------------------------------------------
" Configure (keyword) completion
"-------------------------------------------------------------------------------

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
inoremap <silent> <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <silent> <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-j>"

" Open the completion menu using C-Space, note that C-Space inserts the <Nul> character.
inoremap <silent> <expr> <Nul> pumvisible() ? "" : "\<C-X>\<C-U>\<Down>"

" Escape should always close the completion menu at once.
inoremap <silent> <expr> <Esc> pumvisible() ? "\<C-E>\<Esc>" : "\<Esc>"

" Allow the Enter key to select the first item in the list.
let g:ycm_key_list_select_completion = ['<TAB>', '<CR>']

" Disable YCM auto complete inside the following file types.
let g:ycm_filetypes_to_completely_ignore = { 'gitcommit': 1, 'vim': 1 }

" Configure (keyword) completion.
set completeopt=menuone

" Do not scan Boost include files.
set include=^\\s*#\\s*include\ \\(<boost/\\)\\@!

"-------------------------------------------------------------------------------
" File type specific settings
"-------------------------------------------------------------------------------

" Automatically remove trailing whitespace before write.
function! StripTrailingWhitespace()
    normal mZ
    %s/\s\+$//e
    normal `Z
endfunction

" Syntax highlighting for Qt qmake project files.
au BufEnter *.pro setlocal syntax=pro

" Syntax highlighting for Go.
au BufEnter *.go setlocal syntax=go

" Set tab stop to 1 for Qt UI definition files.
au BufEnter *.ui setlocal tabstop=1
au BufEnter *.ui setlocal shiftwidth=1

" Set tab stop to 1 for CMake files.
au BufEnter CMakeLists.txt setlocal tabstop=2
au BufEnter CMakeLists.txt setlocal shiftwidth=2

" Set tab stop to 4 for Vimscript files.
au BufEnter *.vim setlocal tabstop=4
au BufEnter *.vim setlocal shiftwidth=4

" Strip trailing white spaces in source code.
au BufWritePre .vimrc,*.js,*.cpp,*.hpp,*.php,*.h,*.c :call StripTrailingWhitespace()

" Do not expand tabs for web related source code.
au BufEnter *.php,*.html,*.css,*.js setlocal noexpandtab

" Set text width for C++ code to be able to easily format comments.
au FileType cpp setlocal textwidth=80
au FileType cpp setlocal formatoptions=croqn

" Add support for Doxygen comment leader.
au FileType h,hpp,cpp,c setlocal comments^=:///

" Set text width for Git commit messages.
au BufEnter .git/COMMIT_EDITMSG setlocal textwidth=72

" Set text width for Changelogs, and do not expand tabs.
au BufEnter Changelog setlocal textwidth=80
au BufEnter Changelog setlocal expandtab

" Set text width for reStructured text.
au BufEnter *.rst setlocal textwidth=80

" Set text width for Python to 80 to allow for proper docstring and comment formatting.
au FileType python setlocal textwidth=80
au FileType python setlocal formatoptions=croqn

"-------------------------------------------------------------------------------
" Misc settings
"-------------------------------------------------------------------------------

" Always start editing a file in case a swap file exists.
augroup SimultaneousEdits
    autocmd!
    autocmd SwapExists * :let v:swapchoice = 'e'
augroup End

" Read in a custom Vim configuration local to the working directory.
if filereadable(".project.vim")
    so .project.vim
endif
