call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

set title

set hlsearch
set incsearch
set ignorecase
set smartcase

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

if has("autocmd")
	filetype plugin indent on
endif
