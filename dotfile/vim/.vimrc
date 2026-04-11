set nocompatible

filetype plugin indent on
syntax on

set encoding=utf-8
set hidden
set mouse=a
set ttyfast
set updatetime=300
set timeoutlen=400

set number
set relativenumber
set cursorline
set signcolumn=yes
set colorcolumn=88
set scrolloff=6
set sidescrolloff=8

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
set autoindent
set smartindent
set breakindent

set ignorecase
set smartcase
set incsearch
set hlsearch

set splitbelow
set splitright

set wildmenu
set wildmode=longest:full,full
set completeopt=menuone,noinsert,noselect,popup

set undofile
set undodir=~/.vim/undo//
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//

set backup
set writebackup

set list
set listchars=tab:»·,trail:·,nbsp:␣

set shortmess+=c
set formatoptions+=j
set formatoptions-=o

let mapleader = " "

colorscheme desert

nnoremap <leader>w :write<CR>
nnoremap <leader>q :quit<CR>
nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader>n :set invnumber invrelativenumber<CR>
nnoremap <leader>p "+p
nnoremap <leader>y "+y
vnoremap <leader>y "+y

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

augroup dotfile_general
  autocmd!
  autocmd BufWritePre * if &modifiable && &buftype ==# '' | silent! %s/\s\+$//e | endif
augroup END

augroup dotfile_python
  autocmd!
  autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab textwidth=88
  autocmd FileType python setlocal foldmethod=indent foldlevel=99
  autocmd FileType python setlocal suffixesadd=.py
augroup END

if executable('python3')
  let g:python3_host_prog = exepath('python3')
endif

if has('clipboard')
  set clipboard=unnamedplus
endif

if has('termguicolors')
  set termguicolors
endif

if exists(':terminal')
  nnoremap <leader>tt :terminal<CR>
endif
