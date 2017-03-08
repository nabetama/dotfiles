"---------------------------------------------------------------------------
" Edit:
"

" Smart insert tab setting.
set smarttab
" Exchange tab to spaces.
set expandtab
" Round indent by shiftwidth.
set shiftround
set tabstop=2
set softtabstop=2

" Enable modeline
set modeline

" Use clipboard register.
if (!has('nvim') || $DISPLAY != '') && has('clipboard')
  if has('unnamedplus')
     set clipboard& clipboard+=unnamedplus
  else
     set clipboard& clipboard+=unnamed
  endif
endif

" Enable backspace delete indent and newline.
set backspace=indent,eol,start

" Highlight parenthesis.
set showmatch
" Highlight when CursorMoved.
set cpoptions-=m
set matchtime=1
" Highlight <>.
set matchpairs+=<:>

" Display another buffer when current buffer isn't saved.
set hidden

" Ignore case on insert completion.
set infercase

" Enable folding.
set foldenable
set foldmethod=marker
" Show folding level.
set foldcolumn=1
set fillchars=vert:\|
set commentstring=%s

" Use grep.
set grepprg=grep\ -inH

" keymapping timeout.
set timeout timeoutlen=3000 ttimeoutlen=100

" Set swap.
set nowritebackup
set nobackup
set noswapfile

set virtualedit=all

set noundofile
