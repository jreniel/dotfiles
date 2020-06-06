" bootstrap vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

" initialize vim-plug
call plug#begin()
    
    " sidebar navigation
    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

    " Plug 'tpope/vim-sensible'

    " Python flake8
    Plug 'nvie/vim-flake8'

    " Plug 'mhinz/vim-startify'

    " some 'pretty' theme
    Plug 'ErichDonGubler/vim-sublime-monokai'

    " for block commenting
    Plug 'scrooloose/nerdcommenter'

    " ?
    Plug 'tpope/vim-obsession'
    
    " jedi-vim for autocompletion
    Plug 'davidhalter/jedi-vim'

    " vim-session
    Plug 'xolox/vim-session'

    " vim-misc required by vim-session
    Plug 'xolox/vim-misc'

    " Relative line numberng
    Plug 'jeffkreeftmeijer/vim-numbertoggle'

    " airline
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

call plug#end()

" Toggle NerdTree view using F6
nmap <F6> :NERDTreeToggle<CR>

" Toggle mouse support using F3
map <F3> <ESC>:exec &mouse!=""? "set mouse=" : "set mouse=nv"<CR>

" shut up vim-obsession (I think)
let g:session_autosave = 'no'

" autonumbering
set number relativenumber

" autonumbering toggle
nnoremap <silent> <C-n> :set relativenumber!<cr>

" More 'natural' pane movement
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Required by nercommenter
filetype plugin on
