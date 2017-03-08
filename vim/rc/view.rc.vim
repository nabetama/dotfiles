"---------------------------------------------------------------------------
" View:
"

set list
set listchars=tab:▸\ ,trail:-,extends:»,precedes:«,nbsp:%

" Always display statusline.
set laststatus=2
" Height of command line
set cmdheight=2
" Not show command on statusline
set cmdheight=2
" Not show command on statusline.
set noshowcmd
" Show title.
set title
" Title length.
set titlelen=95
" Disable tabline.
set showtabline=2
set number
syntax enable

" Do not display greetings message at the time of Vim start.
set shortmess=aTI

" Don't create backup.
set nowritebackup
set nobackup
set noswapfile
set backupdir-=.

" Disable bell.
set t_vb=
set novisualbell

set wildmenu
set wildmode=list:longest,full
" Increase history amount.
set history=1000
