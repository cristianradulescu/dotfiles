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
Plug 'joshdick/onedark.vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
  let g:airline_poweline_fonts=1

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  augroup nerd_loader
    autocmd!
    autocmd VimEnter * silent! autocmd! FileExplorer
    autocmd BufEnter,BufNew *
      \  if isdirectory(expand('<amatch>'))
      \|  call plug#load('nerdtree')
      \|  execute 'autocmd! nerd_loader'
      \| endif
  augroup END

  let NERDTreeShowHidden=1
  nnoremap <C-f> :NERDTreeFind %<CR>
  nnoremap <C-n> :NERDTreeToggle <CR>

Plug 'scrooloose/syntastic'
  let g:syntastic_auto_loc_list=1
  let g:syntastic_check_on_open=0
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*

Plug 'airblade/vim-gitgutter'
  let g:gitgutter_updatetime=1000

Plug 'honza/dockerfile.vim'

call plug#end()

" Theme
colorscheme onedark
syntax on
set termguicolors
highlight Normal ctermbg=None
highlight LineNr ctermfg=DarkGrey

" Transparent background for editor and status line
hi Normal guibg=NONE ctermbg=NONE
hi StatusLine ctermbg=NONE guibg=NONE

" General
set nu "Show line numbers
set nowrap " No word wrap
set shiftwidth=2 " Nb of autoindent spaces
set expandtab " Spaces instead of tabs
set softtabstop=2 " Nb of spaces per tab

" Advanced
set ruler " Show row / col info
set mouse=a " Activate mouse
set showcmd

" Annoying temporary files
set backupdir=/tmp//,.
set directory=/tmp//,.
