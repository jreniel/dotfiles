" bootstrap vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

" initialize vim-plug
call plug#begin()
    
    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
    " Plug 'tpope/vim-sensible'
    Plug 'nvie/vim-flake8'
    " Plug 'mhinz/vim-startify'
    Plug 'ErichDonGubler/vim-sublime-monokai'
    Plug 'scrooloose/nerdcommenter'
    Plug 'tpope/vim-obsession'

call plug#end()

" Toggle NerdTree view using F6
nmap <F6> :NERDTreeToggle<CR>

" Toggle mouse support using F3
map <F3> <ESC>:exec &mouse!=""? "set mouse=" : "set mouse=nv"<CR>

" Required by nercommenter
filetype plugin on
