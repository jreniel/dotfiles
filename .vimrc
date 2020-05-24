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

call plug#end()

" Toggle NerdTree view using F6
nmap <F6> :NERDTreeToggle<CR>

" Toggle mouse support using F3
map <F3> <ESC>:exec &mouse!=""? "set mouse=" : "set mouse=nv"<CR>

" Required by nercommenter
filetype plugin on
