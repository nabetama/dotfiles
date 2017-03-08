" python.vim
let python_hithlight_all = 1

" netrw.vim"{{{
let g:netrw_list_hide= '*.swp'
" Change default directory.
set browsedir=current
"}}}


if dein#tap('deoplete.nvim') && has('nvim') "{{{
  let g:loaded_neocomplete = 1
  let g:deoplete#enable_at_startup = 1
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'source ~/.vim/rc/plugins/deoplete.rc.vim'
endif "}}}

if dein#tap('neocomplete.vim') && has('lua') "{{{
  let g:loaded_deoplete = 1
  let g:neocomplete#enable_at_startup = 1
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'source ~/.vim/rc/plugins/neocomplete.rc.vim'
endif "}}}

if dein#tap('neosnippet.vim') "{{{
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'source ~/.vim/rc/plugins/neosnippet.rc.vim'
endif "}}}


if dein#tap('vimshell.vim') "{{{
  nmap [Space]s  <Plug>(vimshell_switch)
  nnoremap !  q:VimShellExecute<Space>

  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'source ~/.vim/rc/plugins/vimshell.rc.vim'
endif "}}}


if dein#tap('unite.vim') "{{{
  let g:unite_enable_start_insert=1
  let g:unite_enable_ignore_case = 1
  let g:unite_enable_smart_case = 1
  noremap <C-p> :Unite file buffer<CR>
  noremap <C-N> :Unite -buffer-name=file file<CR>
  noremap <C-Z> :Unite file_mru<CR>
  nnoremap <space><space> :split<cr> :<C-u>Unite -start-insert file_rec/async<cr>
  nnoremap <space>r <Plug>(unite_restart)
  
  au FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
  au FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
  
  nnoremap <space>p :<C-u>Unite file_rec/async:!<CR>
  nnoremap <space>g :Unite grep:.<cr>
  let g:unite_source_history_yank_enable =1 " history/yanksの有効化
  nnoremap <space>y :Unite history/yank<cr>
  nnoremap <space>s :Unite -quick-match buffer<cr>
  nnoremap <space>t :Unite tab<cr>
  
  if executable('pt') " Unite + the_platinum_searcher {{{
    let g:unite_source_grep_command = 'pt'
    let g:unite_source_grep_default_opts = '--nogroup --nocolor'
    let g:unite_source_grep_recursive_opt = ''
  endif
  " }}}

  nnoremap <silent> ,g  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
  nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>
  nnoremap <silent> ,r  :<C-u>UniteResume search-buffer<CR>
  nnoremap <silent> ,g :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
  " }}}
endif "}}}


if dein#tap('vim-quickrun') "{{{
  nmap <silent> <Leader>r <Plug>(quickrun)
endif "}}}


if dein#tap('vimfiler.vim') "{{{
  nnoremap <silent>   [Space]v   :<C-u>VimFiler -invisible<CR>

  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'source ~/.vim/rc/plugins/vimfiler.rc.vim'
endif "}}}

if dein#tap('vim-gitgutter') "{{{
  let g:gitgutter_sign_added = '✚'
  let g:gitgutter_sign_modified = '➜'
  let g:gitgutter_sign_removed = '✘'
  let g:gitgutter_max_signs = 1000
endif "}}}

if dein#tap('indentLine') "{{{
  let g:indentLine_faster = 1
  nmap <silent><Leader>i :<C-u>IndentLinesToggle<CR>
endif "}}}

if dein#tap('jedi-vim') "{{{
  autocmd MyAutoCmd FileType python
        \ if has('python') || has('python3') |
        \   setlocal omnifunc=jedi#completions |
        \ else |
        \   setlocal omnifunc= |
        \ endif
  let g:jedi#completions_enabled = 0
  let g:jedi#auto_vim_configuration = 0
  let g:jedi#smart_auto_mappings = 0
  let g:jedi#show_call_signatures = 0
endif "}}}

if dein#tap('vim-go') "{{{
  let g:go_highlight_functions = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_structs = 1
endif  "}}}

if dein#tap('vim-easymotion') "{{{
  " <Leader>f{char} to move to {char}
  map  <Leader>f <Plug>(easymotion-bd-f)
  nmap <Leader>f <Plug>(easymotion-overwin-f)

  " s{char}{char} to move to {char}{char}
  nmap s <Plug>(easymotion-overwin-f2)

  " Move to line
  map <Leader>L <Plug>(easymotion-bd-jk)
  nmap <Leader>L <Plug>(easymotion-overwin-line)

  " Move to word
  map  <Leader>w <Plug>(easymotion-bd-w)
  nmap <Leader>w <Plug>(easymotion-overwin-w)
endif"}}}
