" https://neovim.io/doc/user/nvim.html#nvim-from-vim
" bootstrap vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

" initialize vim-plug
call plug#begin()

    Plug 'thaerkh/vim-workspace'

    " sidebar navigation
    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }


    Plug 'lervag/vimtex'

    " Plug 'tpope/vim-sensible'

    " Python flake8
    Plug 'nvie/vim-flake8', { 'for': 'python' }

    " Plug 'mhinz/vim-startify'

    " some 'pretty' theme
    Plug 'ErichDonGubler/vim-sublime-monokai'

    " for block commenting
    " Plug 'scrooloose/nerdcommenter'

    " easier commenting than nerdcommenter
    Plug 'tpope/vim-commentary'

    " ?
    Plug 'tpope/vim-obsession'

    if !has('nvim')
        " jedi-vim for autocompletion
        Plug 'davidhalter/jedi-vim'
    else
        Plug 'deoplete-plugins/deoplete-jedi'
    endif

    " vim-session
    Plug 'xolox/vim-session'

    " vim-misc required by vim-session
    Plug 'xolox/vim-misc'

    " Relative line numberng
    Plug 'jeffkreeftmeijer/vim-numbertoggle'

    " airline
    " Plug 'vim-airline/vim-airline'
    " Plug 'vim-airline/vim-airline-themes'

    " vim-mypy
    " Plug 'integralist/vim-mypy'
    "Plug 'flebel/vim-mypy', { 'for': 'python', 'branch': 'bugfix/fast_parser_is_default_and_only_parser' }

    " vim-markdonw
    Plug 'tpope/vim-markdown'

    " Plug 'nathanaelkane/vim-indent-guides'

    " if has('nvim')
    "    Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
    " endif

    " multicursor support (similar to ctrl+d in sublime)
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}

    Plug 'tpope/vim-eunuch'

    "Plug 'Yggdroot/indentLine'

    " Plug 'ErichDonGubler/vim-sublime-monokai'

    " better monokai
    Plug 'patstockwell/vim-monokai-tasty'

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

" Use Enter to create empty spaces
" nmap <S-Enter> O<Esc>
" nmap <CR> o<Esc>


"if !has('nvim')
    ":color desert
"endif

" Required by nercommenter
filetype plugin on

" For better identation
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

let g:indent_guides_enable_on_vim_startup = 1
" better splitting
set splitbelow
set splitright

if !has('nvim')
    if has("autocmd")
      au BufNewFile,BufRead *.nml set filetype=fortran
      au BufNewFile,BufRead *.namelist set filetype=fortran
    endif
endif

let g:vim_monokai_tasty_italic = 1
colorscheme vim-monokai-tasty
let g:lightline = {
      \ 'colorscheme': 'monokai_tasty',
      \ }
let g:airline_theme='monokai_tasty'

" sublime monokai
" syntax on
" colorscheme sublimemonokai

"set termguicolors
nmap <C-P> :FZF<CR>


"  Latex plugin options

" This is necessary for VimTeX to load properly. The "indent" is optional.
" Note that most plugin managers will do this automatically.
filetype plugin indent on

" This enables Vim's and neovim's syntax-related features. Without this, some
" VimTeX features will not work (see ":help vimtex-requirements" for more
" info).
syntax enable

" Viewer options: One may configure the viewer either by specifying a built-in
" viewer method:
" let g:vimtex_view_method = 'okular'

" Or with a generic interface:
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'

" VimTeX uses latexmk as the default compiler backend. If you use it, which is
" strongly recommended, you probably don't need to configure anything. If you
" want another compiler backend, you can change it as follows. The list of
" supported backends and further explanation is provided in the documentation,
" see ":help vimtex-compiler".
" let g:vimtex_compiler_method = 'latexrun'

" Most VimTeX mappings rely on localleader and this can be changed with the
" following line. The default is usually fine and is the symbol "\".
" let maplocalleader = ","
 
let g:workspace_autocreate = 1

nnoremap <leader>s :ToggleWorkspace<CR>

" let g:workspace_session_directory = $HOME . '/.vim/sessions/'
