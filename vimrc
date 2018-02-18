let mapleader=','

call plug#begin('~/.vim/plugged')
Plug 'wannesm/wmgraphviz.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'jlanzarotta/bufexplorer'
Plug 'kchmck/vim-coffee-script'
Plug 'mxw/vim-jsx'
Plug 'ntpeters/vim-better-whitespace'
Plug 'pangloss/vim-javascript'
Plug 'scrooloose/nerdcommenter'
Plug 'thoughtbot/vim-rspec'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-cucumber'
Plug 'tpope/vim-endwise', { 'for': 'ruby' }
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
call plug#end()

" Settings for vim-better-whitespace
autocmd BufEnter * EnableStripWhitespaceOnSave

" Settings for vim-jsx
let g:jsx_ext_required = 0

" Settings for vim-javascript
let g:javascript_plugin_flow = 1

" RSpec.vim mappings
map <leader>t :call RunCurrentSpecFile()<CR>
map <leader>T :call RunNearestSpec()<CR>

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
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()
  autocmd BufEnter * :call MapCR()
  autocmd BufRead,BufNewFile Podfile set filetype=ruby
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

imap <c-l> <space>=><space>

map <leader>y "*y
" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" Can't be bothered to understand ESC vs <c-c> in insert mode
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
nnoremap <leader><leader> <c-^>
" Close all other windows, open a vertical split, and open this file's test
" alternate in it.
nnoremap <leader>s <c-w>o <c-w>v <c-w>w :call OpenTestAlternate()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ARROW KEYS ARE UNACCEPTABLE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPEN FILES IN DIRECTORY OF CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>n :Rename<space>

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction

function! AlternateForCurrentFile()
  let current_file = expand('%')
  let new_file = current_file

  let in_spec = match(current_file, '^spec/') != -1
  let in_test = match(current_file, '^test/') != -1

  let in_controllers = match(current_file, '\<controllers\>') != -1
  let in_models = match(current_file, '\<models\>') != -1
  let in_views = match(current_file, '\<views\>') != -1
  let in_workers = match(current_file, '\<workers\>') != -1

  let in_app = in_controllers || in_models || in_views || in_workers

  if in_spec || in_test
    if in_spec
      let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
      let new_file = substitute(new_file, '^spec/', '', '')
    elseif in_test
      let new_file = substitute(new_file, '_test\.rb$', '.rb', '')
      let new_file = substitute(new_file, '^test/', '', '')
    end

    if in_app
      let new_file = 'app/' . new_file
    end

    return new_file
  else
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end

    let spec_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let spec_file = 'spec/' . spec_file

    let test_file = substitute(new_file, '\.rb$', '_test.rb', '')
    let test_file = 'test/' . test_file

    if filereadable(test_file)
      return test_file
    else
      return spec_file
    end
  end
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>

" open quickfix after any grep invocation
augroup grepQuickFixGroup
  autocmd QuickFixCmdPost *grep* cwindow
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Selecta Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command)
  try
    let selection = system(a:choice_command . " | selecta " . a:selecta_args)
    " Escape spaces in the file name. That ensures that it's a single argument
    " when concatenated with vim_command and run with exec.
    let selection = substitute(selection, ' ', '\\ ', "g")
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

function! SelectaFile(path, glob)
  call SelectaCommand("find " . a:path . "/* -type f -and -iname '" . a:glob . "' -and -not -iname '*.pyc'", "", ":e")
endfunction

nnoremap <leader>f :call SelectaFile(".", "*")<cr>
nnoremap <leader>gv :call SelectaFile("app/views", "*")<cr>
nnoremap <leader>gc :call SelectaFile("app/controllers", "*")<cr>
nnoremap <leader>gm :call SelectaFile("app/models", "*")<cr>
nnoremap <leader>gh :call SelectaFile("app/helpers", "*")<cr>
nnoremap <leader>gl :call SelectaFile("lib", "*")<cr>
nnoremap <leader>gp :call SelectaFile("public", "*")<cr>
nnoremap <leader>gs :call SelectaFile("public/stylesheets", "*.sass")<cr>
nnoremap <leader>gf :call SelectaFile("features", "*")<cr>

"Fuzzy select
function! SelectaIdentifier()
  " Yank the word under the cursor into the z register
  normal "zyiw
  " Fuzzy match files in the current directory, starting with the word under
  " the cursor
  call SelectaCommand("find * -type f", "-s " . @z, ":e")
endfunction
nnoremap <c-g> :call SelectaIdentifier()<cr>

nnoremap <leader>k :!make<cr>
