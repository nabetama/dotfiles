"---------------------------------------------------------------------------
" FileType:
"

" Enable smart indent
set autoindent smartindent

augroup MyAutoCmd
  autocmd FileType,Syntax,BufEnter,BufWinEnter * call s:my_on_filetype()

  " Auto reload VimScript.
  autocmd BufWritePost,FileWritePost *.vim nested
        \ if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') |
        \ endif

  " Reload .vimrc automatically.
  autocmd BufWritePost .vimrc,vimrc,*.rc.vim,*.toml nested
        \ | source $MYVIMRC | redraw

  autocmd FileType gitcommit,qfreplace setlocal nofoldenable

  autocmd FileType ref nnoremap <buffer> <TAB> <C-w>w

  autocmd FileType python setlocal foldmethod=indent
  autocmd FileType python setlocal completeopt-=preview

  " Update filetype.
  autocmd BufWritePost * nested
  \ if &l:filetype ==# '' || exists('b:ftdetect')
  \ |   unlet! b:ftdetect
  \ |   filetype detect
  \ | endif

  " Improved include pattern.
  autocmd FileType html
        \ setlocal includeexpr=substitute(v:fname,'^\\/','','') |
        \ setlocal path+=./;/
  autocmd FileType php setlocal path+=/usr/local/share/pear
  autocmd FileType apache setlocal path+=./;/

  autocmd FileType go highlight default link goErr WarningMsg |
        \ match goErr /\<err\>/
  autocmd FileType go setlocal completeopt-=preview
augroup END

" Python
let g:python_highlight_all = 1

" Vim
let g:vimsyntax_noerror = 1

" Bash
let g:is_bash = 1

" JavaScript
let g:SimpleJsIndenter_BriefMode = 1
let g:SimpleJsIndenter_CaseIndentLevel = -1

" Markdown
let g:markdown_fenced_languages = []

" Go
if $GOROOT != ''
   set runtimepath+=$GOROOT/misc/vim
endif

let g:markdown_fenced_languages = [
      \  'coffee',
      \  'css',
      \  'erb=eruby',
      \  'javascript',
      \  'js=javascript',
      \  'json=javascript',
      \  'ruby',
      \  'sass',
      \  'xml',
      \  'vim',
      \]

function! s:my_on_filetype() abort "{{{
  " Disable automatically insert comment.
  setl formatoptions-=ro | setl formatoptions+=mMBl

  " Disable auto wrap.
  if &l:textwidth != 70 && &filetype !=# 'help'
    setlocal textwidth=0
  endif

  " Use FoldCCtext().
  if &filetype !=# 'help'
    setlocal foldtext=FoldCCtext()
  endif

  if !&l:modifiable
    setlocal nofoldenable
    setlocal foldcolumn=0
    silent! IndentLinesDisable

    if v:version >= 703
      setlocal colorcolumn=
    endif
  endif

  if &l:filetype != '' || bufname('%') != ''
    redir => filetype_out
    silent! filetype
    redir END
    if filetype_out =~# 'OFF'
      " Lazy loading
      silent! filetype plugin indent on
      syntax enable
    endif
  endif
endfunction "}}}
