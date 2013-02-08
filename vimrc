call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
call pathogen#infect()

let mapleader=','
"if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
"endif

" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

set title
set number
set textwidth=72

set ttimeout
set ttimeoutlen=50

set hlsearch
set incsearch
set ignorecase
set smartcase
set smarttab
set showmatch
set complete-=i

set ts=2 sts=2 sw=2 expandtab
syntax on
if has('gui_running')
  set background=light
else
  set background=dark
endif
colorscheme solarized

set showcmd
set showmode
set laststatus=2
set visualbell
set ruler
set wildmenu
set scrolloff=1
set sidescrolloff=5
set display+=lastline

set autoread
set autowrite
set fileformats=unix,dos,mac
set viminfo^=!

function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history,
  " and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

autocmd BufWritePre *.py,*.js :call <SID>StripTrailingWhitespaces()

if has("autocmd")
	filetype plugin indent on
endif
