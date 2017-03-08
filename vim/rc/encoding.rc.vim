if has('vim_starting') && &encoding !=# 'utf-8'
  set encoding=utf-8
endif

" Default
set fileformat=unix
" Automatic recognition of a new line cord.
set fileformats=unix,dos,mac

if has('multi_byte_ime')
 set iminsert=0 imsearch=0
endif

