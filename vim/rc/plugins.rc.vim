" =====================================================================
" vim-go
" =====================================================================
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1

" =====================================================================
" ctrlp
" =====================================================================
" default
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" file searcher
" use mattn/files
let g:ctrlp_user_command = 'files -a %s'

" cache
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_clear_cache_on_exit = 0

" same vim lazy redraw
let g:ctrlp_lazy_update = 1

" ctrlp window height
let g:ctrlp_max_height = 20

" ignore dir's
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn|node_modules|build)$',
  \ 'file': '\v\.(exe|so|dll|swp|zip|jpg|png)$',
  \ }

