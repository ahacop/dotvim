call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

set ts=2 sts=2 sw=2 expandtab
syntax on
if has('gui_running')
  set background=light
else
  set background=dark
endif
colorscheme solarized

if has("autocmd")
	filetype plugin indent on
endif
