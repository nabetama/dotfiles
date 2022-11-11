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

" For React
Plug 'windwp/nvim-ts-autotag'	" close tags quickly
Plug 'windwp/nvim-autopairs'	" for closing brackets

" Code formatter
Plug 'jose-elias-alvarez/null-ls.nvim'

" Git markers
Plug 'lewis6991/gitsigns.nvim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
