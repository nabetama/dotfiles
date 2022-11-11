set number

call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" LSP
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }

" Auto-complete
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'onsails/lspkind.nvim' " VSCode like pictograms
Plug 'L3MON4D3/LuaSnip'	" Snippet engine

" Syntax highlightings
Plug 'nvim-treesitter/nvim-treesitter'

" fuzzy finder over lists
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Icons
Plug 'nvim-tree/nvim-web-devicons'

" bufferline
Plug 'akinsho/nvim-bufferline.lua'

" Color scheme
Plug 'itchyny/lightline.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 't9md/vim-quickhl'

" Git markers
Plug 'lewis6991/gitsigns.nvim'
" Git
Plug 'dinhhuy258/git.nvim'

" grep tool
Plug 'rking/ag.vim'
" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" QuickRun
Plug 'thinca/vim-quickrun'

" For React
Plug 'windwp/nvim-ts-autotag'	" close tags quickly
Plug 'windwp/nvim-autopairs'	" for closing brackets

" HTML/JSX
Plug 'mattn/emmet-vim'

" Code formatter
Plug 'jose-elias-alvarez/null-ls.nvim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" ----------------------------------------------
"  General settings
" ----------------------------------------------
set autoindent                    " take indent for new line from previous line
set smartindent                   " enable smart indentation
set autoread                      " reload file if the file changes on the disk
set autowrite                     " write when switching buffers
set autowriteall                  " write on :quit
" set clipboard=unnamedplus " TODO:
set colorcolumn=101               " highlight the 80th column as an indicator
set completeopt-=preview          " remove the horrendous preview window
set encoding=utf-8
set expandtab                     " expands tabs to spaces
set list                          " show trailing whitespace
set listchars=tab:\|\ ,trail:▫
set nospell                       " disable spelling
set noswapfile                    " disable swapfile usage
set nowrap
set noerrorbells                  " No bells!
set novisualbell                  " I said, no bells!
" set number                        " show number ruler
set ruler                         " show cursor position
set formatoptions=tcqron          " set vims text formatting options
set softtabstop=2
set tabstop=2
set textwidth=100
set title                         " let vim set the terminal title
set titlelen=95                   " let vim set the terminal title
set updatetime=100                " redraw the status bar often
set laststatus=2                  " statusline height is 2
set matchpairs& matchpairs+=<:>   " add <> to matchpairs
set cmdheight=2                   " command line height
set wildmenu                      " enables a menu at the bottom
set wildmode=list:longest,full    " do completion in the command line via tab
set backspace=indent,eol,start    " Enable backspace deletes indent and new line
set clipboard+=unnamed            " Share the clipboard between vim and Mac OS
filetype plugin on
set omnifunc=syntaxcomplete#Complete    " Omni completion

" Allow vim to set a custom font or color for a word
syntax enable

" set the leader button
let mapleader = ','

" Autosave buffers before leaving them
autocmd BufLeave * silent! :wa

" Command-line mode keymappings
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
" cnoremap <C-n> <Down> TODO
" cnoremap <C-p> <Up> TODO

" easy escape
inoremap jj <esc>
" goto last edited point
nnoremap ;l '.

" jump to pair
nnoremap <tab>  %
vnoremap <tab>  %

" Show full path of file
nnoremap <leader>fp :echo expand("%:p")<cr>

" insert mode keymaps like emacs
imap <c-p> <up>
imap <c-n> <down>
imap <c-b> <left>
imap <c-f> <right>
imap <c-e> <end>
imap <c-d> <del>
imap <c-h> <bs>
" imap <c-a> <esc>^i
" imap <c-k> <esc>^i

"----------------------------------------------
" Colors
"----------------------------------------------
set background=dark
colorscheme PaperColor

highlight Search guibg=DeepPink4 guifg=White ctermbg=53 ctermfg=White

" Toggle background with <leader>bg
" map <leader>bg :let &background = (&background == "dark"? "light" : "dark")<cr>

"----------------------------------------------
" Searching
"----------------------------------------------
set incsearch                     " move to match as you type the search query
set hlsearch                      " disable search result highlighting
set ignorecase                    " ignore match

" Clear search highlights
map <leader>c :nohlsearch<cr>

" These mappings will make it so that going to the next one in a search will
" center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

"----------------------------------------------
" Navigation
"----------------------------------------------
" Disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

"----------------------------------------------
" Splits
"----------------------------------------------
" Create horizontal splits below the current window
set splitbelow      " To open a new window, display it on the lower side
set splitright      " To open a new window, display it on the right side

" Creating splits
nnoremap <leader>v :vsplit<cr>
nnoremap <leader>h :split<cr>

" Move window
map sh <C-w>h
map sk <C-w>k
map sj <C-w>j
map sl <C-w>l

" Closing splits
nnoremap <leader>q :close<cr>

"----------------------------------------------
" Tab
"----------------------------------------------
nnoremap  [Tag] <nop>
nmap      t     [Tag]
for s:n in range(1, 9)
  execute 'nnoremap <sillent> [tag]'.s:n  ':<C-u>tabnext'.s:n.'<cr>'
endfor
" jump
map <silent> [Tag]c :tablast <bar> tabnew<CR>
map <silent> [Tag]x :tabclose<CR>
map <silent> [Tag]n :tabnext<CR>
map <silent> [Tag]p :tabprevious<CR>

" =====================================================================
" Plugin: QuickRun
" =====================================================================
nnoremap <leader>r :QuickRun <enter>

" =====================================================================
" Plugin: vim-quickrun
" =====================================================================
nmap <leader>m <Plug>(quickhl-manual-this)
xmap <leader>m <Plug>(quickhl-manual-this)
nmap <leader>M <Plug>(quickhl-manual-reset)
xmap <leader>M <Plug>(quickhl-manual-reset)


" =====================================================================
" Plugin: nvim-telescope/telescope.nvim
" =====================================================================
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" " =====================================================================
" " Plugin: fzf.vim
" " =====================================================================
" nnoremap <c-p> :call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --others --cached'}))<cr>
" 
" 
" nnoremap <Leader>b :Buffers<CR>
" nnoremap <Leader>x :Commands<CR>
" nnoremap <Leader>f :Files<CR>
" " Files preview
" command! -bang -nargs=? -complete=dir Files
"   \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
" nnoremap <Leader>gf :GFiles<CR>
" 
" " Use ripgrep
" nnoremap <Leader>g :Rg<CR>
" " ripgrep with preview
" command! -bang -nargs=* Rg
"       \ call fzf#vim#grep(
"       \   'rg --line-number --no-heading '.shellescape(<q-args>), 0,
"       \   fzf#vim#with_preview({'options': '--exact --reverse --delimiter : --nth 3..'}, 'right:50%:wrap'))
" 
" " mru files
" command! FZFMru call fzf#run({
"             \ 'source': v:oldfiles,
"             \ 'sink': 'e',
"             \ 'options': '-m -x +s',
"             \ 'down': '40%'})
" nnoremap <Leader>mr :FZFMru<CR>
" 
" =====================================================================
" Plugin: lightline.vim
" =====================================================================
let g:lightline = {
\  'active': {
\    'left': [
\      ['mode', 'paste'],
\      ['readonly', 'filename', 'modified'],
\      ['ale'],
\    ]
\  },
\  'colorscheme': 'landscape',
\  'component_function': {
\    'ale': 'ALEGetStatusLine'
\  }
\}

" =====================================================================
" Plugin: indentLine
" =====================================================================
let g:indent_guides_enable_on_vim_startup = 1
let g:indentLine_faster = 1

" =====================================================================
" Plugin: vim-gitgutter
" =====================================================================
let g:gitgutter_max_signs = 1024
let g:gitgutter_sign_added = '✚'
let g:gitgutter_sign_modified = '➜'
let g:gitgutter_sign_removed = '✘'

" =====================================================================
" Plugin: ale
" =====================================================================
let g:ale_linters = {
\  'go': ['gometalinter'],
\  'javascript': ['eslint'],
\  'jsx': ['stylelint', 'eslint'],
\  'python': ['flake8'],
\}
let g:ale_linter_aliases = {'jsx': 'css'}
let g:ale_set_loclist = 0                   " also disable the loclist
let g:ale_set_quickfix = 1                  " The quickfix list be enabled
let g:ale_lint_on_text_changed = 'never'    " 
let g:ale_lint_on_enter = 1                 " linters to run on opening a file
let g:ale_lint_on_save = 1                  " check at save only
let g:ale_open_list = 0                     " to show Vim windows for the loclist or quickfix items
                                            " when a file contains warnings or errors
let g:ale_keep_list_window_open = 1         " keep the window open even after errors disappear.

let g:ale_sign_column_always = 0            " always show signs columns
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
" move to previous error
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
" move to next error
nmap <silent> <C-j> <Plug>(ale_next_wrap)
let g:ale_echo_msg_format = '[%linter%] %s' " error message format

" fixer
let g:ale_fixers = {
\  'javascript': ['eslint'],
\}
let g:ale_fix_on_save = 1

" =====================================================================
" Plugin: vim-prettier
" =====================================================================
let g:prettier#exec_cmd_async = 1   " forced async
let g:prettier#quickfix_enabled = 0
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue PrettierAsync
" max line length that prettier will wrap on
let g:prettier#config#print_width = 100
" number of spaces per indentation level
let g:prettier#config#tab_width = 2
" use tabs over spaces
let g:prettier#config#use_tabs = 'false'
" print semicolons
let g:prettier#config#semi = 'true'
" single quotes over double quotes
let g:prettier#config#single_quote = 'true'
" print spaces between brackets
let g:prettier#config#bracket_spacing = 'false'
" put > on the last line instead of new line
let g:prettier#config#jsx_bracket_same_line = 'true'
" avoid|always
let g:prettier#config#arrow_parens = 'avoid'
" none|es5|all
let g:prettier#config#trailing_comma = 'all'
" always|never|preserve
let g:prettier#config#prose_wrap = 'preserve'

" =====================================================================
" Language: golang
" =====================================================================
au FileType go set noexpandtab
au FileType go set shiftwidth=4
au FileType go set softtabstop=4
au FileType go set tabstop=4

" ale
let g:ale_go_gometalinter_options = '--fast --enable=staticcheck --enable=gosimple --enable=unused'

" enable syntax highlighting
let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1

" omnicomplete
let g:go_gocode_unimported_packages = 1

" Show type information
let g:go_auto_type_info = 1

" Highlight variable uses
let g:go_auto_sameids = 1

"----------------------------------------------
" Language: Bash
"----------------------------------------------
au FileType sh set noexpandtab
au FileType sh set shiftwidth=2
au FileType sh set softtabstop=2
au FileType sh set tabstop=2

"----------------------------------------------
" Language: zsh
"----------------------------------------------
au FileType zsh set noexpandtab
au FileType zsh set shiftwidth=2
au FileType zsh set softtabstop=2
au FileType zsh set tabstop=2

"----------------------------------------------
" Language: CSS
"----------------------------------------------
au FileType css set expandtab
au FileType css set shiftwidth=2
au FileType css set softtabstop=2
au FileType css set tabstop=2

"----------------------------------------------
" Language: gitcommit
"----------------------------------------------
au FileType gitcommit setlocal spell
au FileType gitcommit setlocal textwidth=100

"----------------------------------------------
" Language: gitconfig
"----------------------------------------------
au FileType gitconfig set noexpandtab
au FileType gitconfig set shiftwidth=2
au FileType gitconfig set softtabstop=2
au FileType gitconfig set tabstop=2

"----------------------------------------------
" Language: HTML
"----------------------------------------------
au FileType html set expandtab
au FileType html set shiftwidth=2
au FileType html set softtabstop=2
au FileType html set tabstop=2

"----------------------------------------------
" Language: JavaScript
"----------------------------------------------
au FileType javascript set expandtab
au FileType javascript set shiftwidth=2
au FileType javascript set softtabstop=2
au FileType javascript set tabstop=2

"----------------------------------------------
" Language: jsx
"----------------------------------------------
augroup FiletypeGroup
    autocmd!
    au BufNewFile,BufRead *.jsx set filetype=javascript.jsx
augroup END

"----------------------------------------------
" Language: JSON
"----------------------------------------------
au FileType json set expandtab
au FileType json set shiftwidth=2
au FileType json set softtabstop=2
au FileType json set tabstop=2

"----------------------------------------------
" Language: LESS
"----------------------------------------------
au FileType less set expandtab
au FileType less set shiftwidth=2
au FileType less set softtabstop=2
au FileType less set tabstop=2

"----------------------------------------------
" Language: Make
"----------------------------------------------
au FileType make set noexpandtab
au FileType make set shiftwidth=2
au FileType make set softtabstop=2
au FileType make set tabstop=2

"----------------------------------------------
" Language: Markdown
"----------------------------------------------
au FileType markdown setlocal spell
au FileType markdown set expandtab
au FileType markdown set shiftwidth=4
au FileType markdown set softtabstop=4
au FileType markdown set tabstop=4
au FileType markdown set syntax=markdown

"----------------------------------------------
" Language: PlantUML
"----------------------------------------------
au FileType plantuml set expandtab
au FileType plantuml set shiftwidth=4
au FileType plantuml set softtabstop=4
au FileType plantuml set tabstop=4

"----------------------------------------------
" Language: Python
"----------------------------------------------
au FileType python set expandtab
au FileType python set shiftwidth=4
au FileType python set softtabstop=4
au FileType python set tabstop=4

"----------------------------------------------
" Language: Ruby
"----------------------------------------------
au FileType ruby set expandtab
au FileType ruby set shiftwidth=2
au FileType ruby set softtabstop=2
au FileType ruby set tabstop=2

"----------------------------------------------
" Language: SQL
"----------------------------------------------
au FileType sql set expandtab
au FileType sql set shiftwidth=2
au FileType sql set softtabstop=2
au FileType sql set tabstop=2

"----------------------------------------------
" Language: TOML
"----------------------------------------------
au FileType toml set expandtab
au FileType toml set shiftwidth=2
au FileType toml set softtabstop=2
au FileType toml set tabstop=2

"----------------------------------------------
" Language: vimscript
"----------------------------------------------
au FileType vim set expandtab
au FileType vim set shiftwidth=4
au FileType vim set softtabstop=4
au FileType vim set tabstop=4

"----------------------------------------------
" Language: YAML
"----------------------------------------------
au FileType yaml set expandtab
au FileType yaml set shiftwidth=2
au FileType yaml set softtabstop=2

"----------------------------------------------
" Language: racket
"----------------------------------------------
au FileType racket set expandtab
au FileType racket set shiftwidth=2
au FileType racket set softtabstop=2

