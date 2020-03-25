let mapleader=','

call plug#begin('~/.vim/plugged')
" appearance
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" editor behavior
Plug '/usr/local/opt/fzf'
Plug 'adelarsq/vim-matchit'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-sensible'

" development
Plug 'dense-analysis/ale'
Plug 'janko-m/vim-test'
Plug 'ludovicchabant/vim-gutentags'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'tpope/vim-fugitive'

" languages
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-endwise', { 'for': 'ruby' }
Plug 'tpope/vim-rails'
call plug#end()

set autowrite
set fileformats=unix,dos,mac
set hlsearch
set ignorecase
set number
set shell=bash
set showcmd
set showmatch
set showmode
set smartcase
set splitbelow
set splitright
set textwidth=72
set title
set ts=2 sts=2 sw=2 expandtab
set visualbell
set wildmode=longest,list

" vim-solarized settings
if has('gui_running')
  set background=light
else
  set background=dark
endif
colorscheme solarized

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
imap <c-c> <esc>

" Clear the search buffer when hitting return
function! MapCR()
  if &buftype ==# 'quickfix'
    execute "unmap <cr>"
  else
    execute "nnoremap <cr> :nohlsearch<cr>"
  endif
endfunction
call MapCR()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPEN FILES IN DIRECTORY OF CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PROMOTE VARIABLE TO RSPEC LET
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>p :PromoteToLet<cr>

" open quickfix after any grep invocation
augroup grepQuickFixGroup
  autocmd QuickFixCmdPost *grep* cwindow
augroup END

augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=78
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
  autocmd! BufReadPost gitcommit
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
  autocmd FileType gitcommit setlocal spell spelllang=en_us
  autocmd FileType gitcommit DiffGitCached | wincmd L

  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et

  autocmd! BufRead,BufNewFile *.sass setfiletype sass

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Indent p tags
  "autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()
  autocmd BufEnter * :call MapCR()
  autocmd BufRead,BufNewFile Podfile set filetype=ruby
augroup END

let g:airline#extensions#ale#enabled = 1

" Fzf 
nnoremap <leader>ff :GFiles<CR>
nnoremap <Leader>fb :Buffers<CR>
nnoremap <Leader>fh :History<CR>
nnoremap <Leader>fc :Commits<CR>
nnoremap <Leader>ft :Tags<CR>

" hide statusline when fzf buffer is open
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" Development specific

" Invoke make
nnoremap <leader>k :!make<cr>

" vim-test mappings
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>s :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

" enable coc status in airline
let g:airline#extensions#coc#enabled = 1

" gutentags
let g:gutentags_generate_on_new = 0
let g:gutentags_cache_dir = "~/.tags_cache"

let g:ale_linters = {
\   'javascript': ['eslint'],
\   'ruby': ['rubocop'],
\}

let g:ale_linters_explicit = 1
let g:airline#extensions#ale#enabled = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Language specific

" Set asm as kickass syntax
autocmd BufRead *.asm set filetype=kickass

" javascript
let g:jsx_ext_required = 1 " syntax highlighting only on .jsx files

command! -nargs=0 Prettier :CocCommand prettier.formatFile
