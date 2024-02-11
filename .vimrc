" Discard VI compatibility
set nocompatible

scriptencoding utf-8

" Auto-install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

Plug 'airblade/vim-gitgutter'
  let g:gitgutter_updatetime=1000

call plug#end()

" Theme & colors
set t_Co=256
colorscheme catppuccin_mocha
syntax on
set termguicolors
highlight Normal guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermfg=DarkGrey
highlight CursorLine ctermbg=DarkGrey ctermbg=NONE

" General
set nu "Show line numbers
set nowrap " No word wrap
set shiftwidth=2 " Nb of autoindent spaces
set expandtab " Spaces instead of tabs
set softtabstop=2 " Nb of spaces per tab
set cursorline " Highlight current line

" Advanced
set ruler " Show row / col info
set mouse=a " Activate mouse
set showcmd

" Annoying temporary files
set backupdir=/tmp//,.
set directory=/tmp//,.
