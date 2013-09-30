set nocompatible
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

"" Pathogen
call pathogen#infect()

" use comma as <Leader> key instead of backslash
let mapleader=","

" Needed to load pathogen help files
Helptags

" double percentage sign in command mode is expanded
" to directory of current file - http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" autoopen NERDTree and focus cursor in new document
" autocmd VimEnter * NERDTree
autocmd VimEnter * NERDTreeTabsOpen
autocmd VimEnter * wincmd p

" Solarized color scheme
syntax enable
set background=dark
colorscheme solarized

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

" Tab navigation with brackets
" map <C-[> :tabprev<cr>:wincmd p<cr>
" map <C-]> :tabnext<cr>:wincmd p<cr>

" NerdTree {
    map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>

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

map <C-]> :tabnext<CR>
map <C-[> :tabprev<CR>

