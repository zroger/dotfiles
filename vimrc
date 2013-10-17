set nocompatible
filetype off                    " required for vundle

" Set up vundle
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" Let Vundle manage Vundle
Bundle 'gmarik/vundle'

Bundle 'altercation/vim-colors-solarized'
Bundle 'scrooloose/nerdtree'
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'kien/ctrlp.vim'
Bundle 'airblade/vim-gitgutter'
Bundle 'majutsushi/tagbar'
Bundle 'christoomey/vim-tmux-navigator'
Bundle 'klen/python-mode'

filetype plugin indent on       " enable filetype after bundle imports

set encoding=utf-8
set showcmd                     " display incomplete commands
set number
set ruler

" Keep swp files under ~/.vim/swap
set directory=~/.vim/swap,~/tmp,.

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=4 shiftwidth=4      " a tab is two spaces
set expandtab                   " use spaces, not tabs
set backspace=indent,eol,start  " backspace through everything in insert mode

" Give some context while scrolling.
set scrolloff=3

"" Visible whitespace
set list
" Use the same symbols as TextMate for tabstops
" and a handy dot for trailing spaces.
set listchars=tab:▸\ ,eol:¬,trail:·,extends:›,precedes:‹

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

" use comma as <Leader> key instead of backslash
let mapleader=","

" autoopen NERDTree and focus cursor in new document
" autocmd VimEnter * NERDTree
autocmd VimEnter * NERDTreeTabsOpen
autocmd VimEnter * wincmd p

" Solarized color scheme
syntax enable
set background=dark
colorscheme solarized

" Safe-guard against accidentally stumbling into Ex mode.
nnoremap Q <nop>

" sudo save with :w!!
cmap w!! w !sudo tee % >/dev/null

" navigate more naturally through wrapped lines.
nnoremap j gj
nnoremap k gk

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" NerdTree {
    map <F2> :NERDTreeToggle<CR>:NERDTreeMirror<CR>

    let NERDTreeShowBookmarks=1
    let NERDTreeShowHidden=1
    let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
    " Keep NERDTree open after selecting a file
    let NERDTreeQuitOnOpen=0

    let g:nerdtree_tabs_open_on_console_startup=1
" }


" Highlight trailing whitespace like an error.
match ErrorMsg '\s\+$'

" Removes trailing spaces
function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction

autocmd FileType python,php autocmd FileWritePre    * :call TrimWhiteSpace()
autocmd FileType python,php autocmd FileAppendPre   * :call TrimWhiteSpace()
autocmd FileType python,php autocmd FilterWritePre  * :call TrimWhiteSpace()
autocmd FileType python,php autocmd BufWritePre     * :call TrimWhiteSpace()


" Python-mode
" Activate rope
" Keys:
" K             Show python docs
" <Ctrl-Space>  Rope autocomplete
" <Ctrl-c>g     Rope goto definition
" <Ctrl-c>d     Rope show documentation
" <Ctrl-c>f     Rope find occurrences
" <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            Jump on previous class or function (normal, visual, operator modes)
" ]]            Jump on next class or function (normal, visual, operator modes)
" [M            Jump on previous class or method (normal, visual, operator modes)
" ]M            Jump on next class or method (normal, visual, operator modes)
let g:pymode_rope = 1

" Documentation
let g:pymode_doc = 1
let g:pymode_doc_key = 'K'

"Linting
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8"
" Auto check on save
let g:pymode_lint_write = 1

" Support virtualenv
let g:pymode_virtualenv = 1

" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_key = '<leader>b'

" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
let g:pymode_folding = 0

