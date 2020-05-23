autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
set number

set colorcolumn=81
set runtimepath^=~/.vim/bundle/ctrlp.vim

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O


map <C-e> :!eslint %<CR>
map <C-n> :!yarn dev<CR>

map <C-z> :!rspec %<CR>
map <C-a> :!rspec<CR>

map <C-g> :!go run %<CR>

map <C-\> :NERDTreeToggle<CR>
map <C-p> :CrtlP<CR>
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_show_hidden = 1

call plug#begin('~/.vim/plugged')  
	Plug 'junegunn/fzf'
	Plug 'mattn/emmet-vim'
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    Plug 'preservim/nerdtree'
    Plug 'thoughtbot/vim-rspec'
    Plug 'pangloss/vim-javascript'
	Plug 'ctrlpvim/ctrlp.vim'''
	Plug 'mxw/vim-jsx'
    Plug 'vim-ruby/vim-ruby'
    Plug 'dracula/vim'
	Plug 'eslint/eslint'
	Plug 'w0rp/ale'
call plug#end()

let g:ale_fixers = {}
let g:ale_fixers.javascript = ['eslint']
let g:ale_fix_on_save = 1

filetype indent off

color dracula
