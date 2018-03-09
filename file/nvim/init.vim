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
Plug 'lambdatoast/elm.vim'
Plug 'nathanaelkane/vim-indent-guides'
call plug#end()

"
" Plugin options
"
let g:indent_guides_auto_colors = 0
highlight IndentGuidesOdd  ctermbg=232
highlight IndentGuidesEven ctermbg=240
let g:gitgutter_override_sign_column_highlight = 0
set updatetime=200

"
" General options
"
filetype plugin indent on
syntax enable
let &t_Co=256                  " More terminal colours
set autoread                   " Show changes if file changed from outside
set background=dark            " Say I prefer dark terminals, just in case
set backspace=indent,eol,start " Backspace through everything
set guicursor= " Evilvte bug workaround; see neovim/neovim#7722
set mouse=a                    " Support mouse
set shortmess+=I               " Disable intro splash
set laststatus=0               " Hide status bar
set noerrorbells               " Quiet
set tabstop=4 shiftwidth=4 expandtab
set hlsearch incsearch ignorecase smartcase
set nobackup nowritebackup noswapfile
" Don't continue comments with o or O
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"
" Language-specific
"
autocmd BufEnter *.eprime set filetype=eprime
autocmd BufEnter *.esl set filetype=lisp
autocmd BufEnter *.param set filetype=eprime
autocmd BufEnter *.pegjs set filetype=javascript
autocmd BufEnter *.t set filetype=terra
autocmd FileType elm setlocal shiftwidth=2 tabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType ls setlocal shiftwidth=2 tabstop=2
autocmd FileType make set noexpandtab

"
" Remaps
"
let mapleader = ","
cmap w!! w !sudo tee % >/dev/null
ino <C-c> <ESC>
inoremap jk <ESC>
map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
nnoremap <leader><space> :nohl<CR>
nnoremap <leader>c :set cursorcolumn!<cr>
nnoremap <leader>i :IndentGuidesToggle<cr>
nnoremap <leader>l :set number!<cr>
nnoremap <leader>ws :source $MYVIMRC<CR>
nnoremap <leader>y :%y+<cr>
nnoremap <m-c> :wq<CR>
nnoremap H ^
nnoremap K K<cr>
nnoremap L $
nnoremap N Nzzzv
nnoremap UI :wq<CR>
nnoremap UJ :w<CR>
nnoremap n nzzzv
noremap ; :

"
" Highlights
"
highlight clear SignColumn
highlight Normal ctermbg=none
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
highlight Comment ctermfg=241
highlight Visual ctermbg=238
" Highlight 80th column
set colorcolumn=+1
highlight ColorColumn ctermbg=232
