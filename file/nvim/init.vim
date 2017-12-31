"
" Load plugins
"
call plug#begin('~/.local/nvim/plugged')
Plug 'gkz/vim-ls'
Plug 'vim-scripts/terra.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'tpope/vim-markdown'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'reedes/vim-pencil'
Plug 'lambdatoast/elm.vim'
Plug 'nathanaelkane/vim-indent-guides'
call plug#end()

"
" General
"
" Basics
filetype plugin indent on       " load file type plugins + indentation
syntax enable
set laststatus=0                " Hide filename and status bar
set shortmess+=I                " Disable starting splash screen
set autoread                    " If file changed from outside, reflect changes
set noerrorbells                " Just in case I'm on a dumb TTY
let &t_Co=256                   " More terminal colours please
set mouse=a                     " Activate mouse support
set backspace=indent,eol,start  " Backspace through everything in insert mode
" Work around terminal emulator escape bug (e.g. in evilvte)
" More info at neovim/neovim#7722
set guicursor=
" Tabs
set tabstop=4                   " A tab is 4 col
set shiftwidth=4                " With > or <, indent by 4 columns
set expandtab                   " Change tabs to spaces automatically
set background=dark             " Say I prefer dark terminals, just in case
" Searching
set hlsearch                    " Highlight results
set incsearch                   " Refine search while typing
set ignorecase                  " Make searches case insensitive...
set smartcase                   " ...unless they contain a capital letter
" Don't continue comments when hitting  o or O in normal mode
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Disable backups and swap files
set nobackup
set nowritebackup
set noswapfile


"
" Language-specific
"
autocmd FileType ls setlocal shiftwidth=2 tabstop=2         " LiveScript
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 " JavaScript
autocmd FileType elm setlocal shiftwidth=2 tabstop=2        " Elm
autocmd FileType make set noexpandtab                       " Makefiles
autocmd BufEnter *.t set filetype=terra          " Detect Terra
autocmd BufEnter *.eprime set filetype=eprime    " Detect ESSENCE'
autocmd BufEnter *.param set filetype=eprime     " Detect ESSENCE'
autocmd BufEnter *.esl set filetype=lisp         " Detect eslisp
autocmd BufEnter *.pegjs set filetype=javascript " Detect pegjs

"
" Auto-spelling
"
iabbrev adn and
iabbrev nad and
iabbrev teh the
iabbrev hte the
iabbrev eht the
iabbrev nto not
iabbrev waht what
iabbrev whta what
iabbrev mkae make
iabbrev taht that
iabbrev thta that
iabbrev evething everything
iabbrev everyhting everything
iabbrev sometiems sometimes

"
" Remaps
"
let mapleader = ","
noremap ; :
" Delete next surrounding parentheses
nnoremap dsn mx%%x``x`x
nnoremap <leader>c :set cursorcolumn!<cr>
" Text-wrap whole file
nnoremap Q mxgggqG`x
" :w HARDER
cmap w!! w !sudo tee % >/dev/null
" :w
nnoremap UJ :w<CR>
" :wq
nnoremap UI :wq<CR> |" wq fast
" Esc
inoremap jk <ESC>
ino <C-c> <ESC>
" Copy entire buffer
nnoremap <leader>y :%y+<cr>
" Beginning and end of line fast
nnoremap H ^
nnoremap L $
" Dismiss 'shell returned' dialog when consulting manual
nnoremap K K<cr>
" Put search result in middle of window and unfold
nnoremap n nzzzv
nnoremap N Nzzzv
" Delete lines from insert mode
inoremap <C-d> <ESC>ddi
" Insert lines above from insert mode
inoremap <C-o> <esc>O
" Toggle search highlight
nnoremap <leader><space> :nohl<CR>
" Edit config
nnoremap <leader>we :split $MYVIMRC<CR>
" Source config
nnoremap <leader>ws :source $MYVIMRC<CR>
" Toggle line numbering
nnoremap ,l :set number!<cr>

" XXX I disabled these because the Markdown thing doesn't work in neovim, and
" remark has changed API since I wrote this.
"
" Markdown-format link to first matching Google result
"vnoremap <C-l> "zyi[<esc>`>la]<esc>l:let link=system('gluck ' . shellescape(getreg("z")))<cr>i<c-r>=link<cr><esc>`>lla(<esc>A)<esc>J`>ll
" Switch between link modes
"nnoremap <leader>mr :%!remark --silent --use remark-reference-links<cr>
"nnoremap <leader>mi :%!remark --silent --use remark-inline-links<cr>

" Incremental search plugin
"
" XXX I disabled this because of visual bugs until
" https://github.com/neovim/neovim/pull/6566 is merged.
"
"map / <Plug>(incsearch-forward)
"map ? <Plug>(incsearch-backward)
"map g/ <Plug>(incsearch-stay)

highlight Normal ctermbg=none
let g:indent_guides_auto_colors = 0
highlight IndentGuidesOdd  ctermbg=0
highlight IndentGuidesEven ctermbg=235

"
" Highlights
"
" Highlight overflow on lines longer than 80 characters
highlight OverLength ctermbg=darkred
match OverLength /\%80v./
" Highlight spaces at the ends of lines
highlight EndSpaces ctermbg=darkgrey
match EndSpaces /\s\+$/
" Highlight ~ and @ non-characters ("outside-file" markers)
highlight NonText ctermfg=240
" Make mode indicators stand out
highlight ModeMsg ctermbg=cyan ctermfg=16 cterm=none
" Tweaks
highlight Search ctermbg=119 ctermfg=Black
highlight Comment ctermfg=240
highlight Visual ctermbg=238

"
" Plugin options
"
highlight clear SignColumn  " Kill vim-gitgutter's bg colour
let g:pencil#joinspaces = 1 " Insert 2 spaces after sentences
