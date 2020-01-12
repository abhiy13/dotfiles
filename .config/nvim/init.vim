set nocompatible
filetype off    

set rtp+=/home/abhiy13/.vim/bundle/Vundle.vim
set rtp+=~/.vim/bundle/
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'itchyny/lightline.vim'
Plugin 'skywind3000/asyncrun.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
Plugin 'morhetz/gruvbox'
call vundle#end()  
filetype plugin indent on

set laststatus=2
set mouse=a
set tabstop=2
set shiftwidth=2
set smarttab
set autoindent
set autoread
syntax on
set number
set softtabstop=0
set expandtab 
set title
set clipboard=unnamedplus
set nowrap
set nohlsearch

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" let g:ycm_server_python_interpreter = 'python'
let g:ycm_global_ycm_extra_conf = '~/.config/nvim/ycm_global_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_show_diagnostics_ui = 1
let g:ycm_min_num_of_chars_for_completion = 3

if has('nvim')
    autocmd TermOpen term://* startinsert
    autocmd TermOpen * set bufhidden=hide 
endif
colorscheme solarized8_high
set background=light

" " Let's save undo info!
" if !isdirectory($HOME."/.vim")
"     call mkdir($HOME."/.vim", "", 0770)
" endif
" if !isdirectory($HOME."/.vim/undo-dir")
"     call mkdir($HOME."/.vim/undo-dir", "", 0700)
" endif
" set undodir=~/.vim/undo-dir
" set undofile


imap <C-d> <C-[>diwi
noremap <F4> :!<CR>
map <C-DOWN> <C-E>
map <C-UP> <C-Y>
map <C-c> "+y<CR>
noremap <c-A> :%y+<CR>
noremap <c-S> :w<CR>
noremap <c-T> :tabn<CR>
noremap <c-N> :tabe<CR>
noremap <F7> :make all && make test<CR>
noremap <F8> :terminal g++ -std=c++14 -Wall -O2 %:r.cpp -o %:r<CR>
autocmd Filetype python noremap <F9> :w \| terminal python3 %<CR>
autocmd Filetype c,cpp noremap <F9> :w \| :!gnome-terminal -- bash -c "g++ -std=c++14 -pedantic -Wall -Wunused -Wuninitialized -Wfloat-equal -Woverflow -Wshadow  -Wextra  -Wconversion -DDEBUG %:r.cpp -o %:r ; echo;echo;  echo Press ENTER to continue; read line;exit; exec bash" <CR><CR>
noremap <F10> :terminal ./"%<" <CR>
noremap <c-B> :terminal ./"%<" < in<CR>
noremap <c-Z> :u<CR>

" to run with gnome-terminal
"  :!gnome-terminal -- bash -c "command ; echo;echo;  echo Press ENTER to continue; read line;exit; exec bash" 
