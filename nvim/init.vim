" Requires neovim.git master HEAD for builtin LSP support.

" Plugins {{{

call plug#begin(stdpath('data') . '/plugged')
Plug 'morhetz/gruvbox'
Plug 'neovim/nvim-lsp'
Plug 'ncm2/float-preview.nvim'
Plug 'tpope/vim-vinegar'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'cespare/vim-toml'
call plug#end()

" }}}

" Basic configuration {{{

" Note: Neovim is always "nocompatible".

filetype plugin indent on
syntax on

set nobackup
set nowritebackup
set noswapfile
set hidden
set updatetime=300
set shortmess+=c
set signcolumn=yes
set novb
set relativenumber
set hlsearch
set incsearch
set smartcase
set wildmode=full
set wildignore+=*/.git/*
set autoindent
set backspace=indent,eol,start
set expandtab
set foldlevelstart=20
set foldmethod=syntax
set linebreak
set mouse=a
set nowrap
set scrolloff=5
set shiftwidth=2 tabstop=2 softtabstop=2
set splitbelow splitright
set timeoutlen=300
set wrapmargin=0

" }}}

" Theming {{{

set termguicolors
set background=dark
colorscheme gruvbox
set guioptions=
"highlight Normal guibg=None

" }}}

" Netrw {{{

let g:netrw_banner = 0
let g:netrw_liststyle = 1
let g:netrw_list_hide = netrw_gitignore#Hide() . ',' . &wildignore

" }}}

" General key bindings {{{

let g:mapleader = ','
nnoremap <leader><space> :nohl<cr>
nnoremap ; :

vnoremap < <gv
vnoremap > >gv

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

vnoremap <up> <nop>
vnoremap <down> <nop>
vnoremap <left> <nop>
vnoremap <right> <nop>

nnoremap <C-n> :tabn<cr>
nnoremap <C-p> :tabp<cr>
nnoremap <tab> %
nnoremap Z ZZ
nnoremap <leader>f :Files<cr>

inoremap jj <esc>

" }}}

" LSP {{{

autocmd filetype rust nnoremap <buffer> <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<cr>
autocmd filetype rust nnoremap <buffer> <silent> K     <cmd>lua vim.lsp.buf.hover()<cr>
autocmd filetype rust nnoremap <buffer> <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<cr>
autocmd filetype rust nnoremap <buffer> <silent> gr    <cmd>lua vim.lsp.buf.references()<cr>
autocmd filetype rust nnoremap <buffer> <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<cr>
autocmd filetype rust setlocal omnifunc=v:lua.vim.lsp.omnifunc

lua << EOF
local nvim_lsp = require'nvim_lsp'
nvim_lsp.rust_analyzer.setup{}
EOF

sign define LspDiagnosticsErrorSign text=✗ texthl=LspDiagnosticsError linehl= numhl=
sign define LspDiagnosticsWarningSign text=⚠ texthl=LspDiagnosticsWarning linehl= numhl=
sign define LspDiagnosticsInformationSign text=ℹ texthl=LspDiagnosticsInformation linehl= numhl=

" }}}

" FloatPreview {{{

function! DisableExtras()
  call nvim_win_set_option(g:float_preview#win, 'number', v:false)
  call nvim_win_set_option(g:float_preview#win, 'relativenumber', v:false)
  call nvim_win_set_option(g:float_preview#win, 'cursorline', v:false)
endfunction

autocmd User FloatPreviewWinOpen call DisableExtras()

let g:float_preview#docked = 1
set completeopt=menu

" }}}
