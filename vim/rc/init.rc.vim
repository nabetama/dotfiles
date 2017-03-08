" Use ',' instead of '\'.
" Use <Leader> in global plugin.
let g:mapleader = ','

let g:maplocalleader = 'm'

let $CACHE = expand('~/.cache')

if !isdirectory(expand($CACHE))
  call mkdir(expand($CACHE), 'p')
endif

" Set augroup
augroup MyAutoCmd
  autocmd!
augroup END

" if filereadable(expand('~/.secret_vimrc'))
"   execute 'source' expand('~/.secret_vimrc')
" endif

" Set runtimepath. "{{{
let s:dein_dir = finddir('dein.vim', '.;')
if s:dein_dir != '' || &runtimepath !~ '/dein.vim'
  if s:dein_dir == '' && &runtimepath !~ '/dein.vim'
    let s:dein_dir = expand('$CACHE/dein')
          \. '/repos/github.com/Shougo/dein.vim'

    if !isdirectory(s:dein_dir)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
    endif
  endif

  execute ' set runtimepath^=' . fnamemodify(s:dein_dir, ':p')
endif

let g:loaded_neobundle = 1
"}}}
