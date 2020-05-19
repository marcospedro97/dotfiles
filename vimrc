autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
set number

set colorcolumn=81

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

set tabstop=4

map <C-n> :!yarn dev<CR>
map <C-z> :!rspec %<CR>
map <C-a> :!rspec<CR>
map <C-g> :!go run %<CR>
map <C-\> :NERDTreeToggle<CR>

call plug#begin('~/.vim/plugged')  
    Plug 'mattn/emmet-vim'
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    Plug 'preservim/nerdtree'
    Plug 'thoughtbot/vim-rspec'
    Plug 'pangloss/vim-javascript'
    Plug 'mxw/vim-jsx'
    Plug 'vim-ruby/vim-ruby'
    Plug 'dracula/vim'
call plug#end()

color dracula
