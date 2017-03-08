"---------------------------------------------------------------------------
" Key-mappings:
"

" Use <C-Space>.
nmap <C-Space>  <C-@>
cmap <C-Space>  <C-@>

" Visual mode keymappings: "{{{
" <TAB>: indent.
xnoremap <TAB>  >
" <S-TAB>: unindent.
xnoremap <S-TAB>  <
" }}}


" Command-line mode keymappings:"{{{
" <C-a>, A: move to head.
cnoremap <C-a>          <Home>
" <C-b>: previous char.
cnoremap <C-b>          <Left>
" <C-d>: delete char.
cnoremap <C-d>          <Del>
" <C-e>, E: move to end.
cnoremap <C-e>          <End>
" <C-f>: next char.
cnoremap <C-f>          <Right>
" <C-n>: next history.
cnoremap <C-n>          <Down>
" <C-p>: previous history.
cnoremap <C-p>          <Up>
" <C-k>, K: delete to end.
cnoremap <C-k> <C-\>e getcmdpos() == 1 ?
      \ '' : getcmdline()[:getcmdpos()-2]<CR>
" <C-y>: paste.
cnoremap <C-y>          <C-r>*
" <C-g>: Exit.
cnoremap <C-g>          <C-c>
"}}}

" Disable ZZ.
nnoremap ZZ  <Nop>

" easy escape. "{{{
inoremap jj <ESC>
inoremap jf <ESC>
"}}}

" goto last edited point. {{{
nnoremap ;l '.
" }}}

" tabで対応ペアにジャンプ {{{
nnoremap <Tab> %
vnoremap <Tab> %
" }}}

" fold {{{
set foldmethod=marker
nmap <silent> ,fc :<C-U>%foldclose<CR>
nmap <silent> ,fo :<C-U>%foldopen<CR>
nmap <silent> ,fO ,zR<CR>
" }}}

" Tab settings {{{
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for s:n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.s:n  ':<C-u>tabnext'.s:n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ
" }}}

" quickhighlight {{{
nmap <Leader>m <Plug>(quickhl-manual-this)
xmap <Leader>m <Plug>(quickhl-manual-this)
nmap <Leader>M <Plug>(quickhl-manual-reset)
xmap <Leader>M <Plug>(quickhl-manual-reset)
" }}}

" QuickRun {{{
nnoremap <Space>q :QuickRun <Enter>
" }}}

" Show full path of file {{{
nnoremap <Leader>fp :echo expand("%:p")<CR>
" }}}
