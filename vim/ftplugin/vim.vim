setl fileencoding=utf-8
setl tabstop=2
setl softtabstop=2
setl shiftwidth=2
setl smarttab

setl expandtab
setl autoindent
setl nosmartindent
setl cindent

setl colorcolumn=99
setl foldmethod=indent
setl foldlevel=99

let s:save_cpo = &cpo
set cpo&vim


if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setl modeline<'

" setlocal nomodeline

" set indent.
setlocal shiftwidth=2 softtabstop=2

setlocal iskeyword+=:,#

" For gf.
let &l:path = join(map(split(&runtimepath, ','), 'v:val."/autoload"'), ',')
setlocal suffixesadd=.vim
setlocal includeexpr=fnamemodify(substitute(v:fname,'#','/','g'),':h')

let &cpo = s:save_cpo
