" https://neovim.io/doc/user/nvim.html#nvim-from-vim
" bootstrap vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

set rtp+=~/.fzf
" if executable('python3') == 0
set rtp+=~/.miniconda3/bin
let g:python3_host_prog = '~/.miniconda3/bin/python3'
" endif

" initialize vim-plug
call plug#begin()
    Plug 'ErichDonGubler/vim-sublime-monokai'
    Plug 'Yggdroot/indentLine'
    Plug 'dense-analysis/ale'
    Plug 'edluffy/hologram.nvim'
    Plug 'github/copilot.vim', {'branch': 'release'}
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }
    Plug 'junegunn/goyo.vim'
    Plug 'junegunn/limelight.vim'
    Plug 'kamykn/spelunker.vim'
    Plug 'lervag/vimtex'
    Plug 'lifepillar/vim-gruvbox8'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'nvie/vim-flake8', { 'for': 'python' }
    Plug 'rust-lang/rust.vim'
    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
    Plug 'thaerkh/vim-workspace'
    Plug 'tpope/vim-commentary'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'vim-python/python-syntax'
    Plug 'w0rp/ale'
    Plug 'kamykn/popup-menu.nvim'
    Plug 'mbbill/undotree'
    Plug 'leafgarland/typescript-vim'
    if !has('nvim')
        Plug 'davidhalter/jedi-vim'
    else
        Plug 'deoplete-plugins/deoplete-jedi'
    endif
    " Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
    " Plug 'godlygeek/tabular' | Plug 'plasticboy/vim-markdown'
    " Plug 'vim-scripts/CD'
    " Plug 'tpope/vim-sensible'
    " Plug 'mhinz/vim-startify'
    " ?
    " Plug 'tpope/vim-obsession'
    " vim-session
    Plug 'xolox/vim-session'
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

    if has('nvim')
       " syntax highlighting
       Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
    endif

    " multicursor support (similar to ctrl+d in sublime)
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}

    Plug 'tpope/vim-eunuch'

    "Plug 'Yggdroot/indentLine'

    " Plug 'ErichDonGubler/vim-sublime-monokai'

    " better monokai
    Plug 'patstockwell/vim-monokai-tasty'

    Plug 'dccsillag/magma-nvim', { 'do': ':UpdateRemotePlugins' }

    " Plug 'yangye1098/vim-ipynb'

call plug#end()

" Toggle NerdTree view using F6
nmap <F6> :NERDTreeToggle<CR>

" Toggle mouse support using F3
map <F3> <ESC>:exec &mouse!=""? "set mouse=" : "set mouse=nv"<CR>

set nospell

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
let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'

" VimTeX uses latexmk as the default compiler backend. If you use it, which is
" strongly recommended, you probably don't need to configure anything. If you
" want another compiler backend, you can change it as follows. The list of
" supported backends and further explanation is provided in the documentation,
" see ":help vimtex-compiler".
" let g:vimtex_compiler_method = 'latexmk'

" Most VimTeX mappings rely on localleader and this can be changed with the
" following line. The default is usually fine and is the symbol "\".
" let maplocalleader = ","
 
let g:workspace_autocreate = 1

nnoremap <leader>s :ToggleWorkspace<CR>

let g:workspace_session_directory = $HOME . '/.vim/sessions/'


" Yggdroot/indentLine
let g:indentLine_leadingSpaceChar='·'
let g:indentLine_leadingSpaceEnabled='1'

" vim-python/python-syntax
let g:python_highlight_all = 1


" w0rp/ale (python) syntax-check
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters = {'python': ['flake8']}


" Airline
let g:airline_left_sep  = ''
let g:airline_right_sep = ''
let g:airline#extensions#ale#enabled = 1
let airline#extensions#ale#error_symbol = 'E:'
let airline#extensions#ale#warning_symbol = 'W:'


set nowrap

let g:enable_spelunker_vim = 0

" normal/insert
" <Plug>MarkdownPreview
" <Plug>MarkdownPreviewStop
" <Plug>MarkdownPreviewToggle
let g:mkdp_auto_start = 0
" example
" nmap <C-s> <Plug>MarkdownPreview
" nmap <M-s> <Plug>MarkdownPreviewStop
" nmap <C-p> <Plug>MarkdownPreviewToggle
"
"
"
" magma
nnoremap <silent><expr> <LocalLeader>r  :MagmaEvaluateOperator<CR>
nnoremap <silent>       <LocalLeader>rr :MagmaEvaluateLine<CR>
xnoremap <silent>       <LocalLeader>r  :<C-u>MagmaEvaluateVisual<CR>
nnoremap <silent>       <LocalLeader>rc :MagmaReevaluateCell<CR>
nnoremap <silent>       <LocalLeader>rd :MagmaDelete<CR>
nnoremap <silent>       <LocalLeader>ro :MagmaShowOutput<CR>

let g:magma_automatically_open_output = v:false
let g:magma_image_provider = "ueberzug"


let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0

inoremap <silent><expr> <TAB>
