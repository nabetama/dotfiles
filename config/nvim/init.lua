print('init.lua')

vim.cmd.packadd "packer.nvim"

require("packer").startup(function()
	use 'tpope/vim-fugitive'
	use 'airblade/vim-gitgutter'
	use 'nvim-tree/nvim-web-devicons'
	use 'prabirshrestha/vim-lsp'
	use 'mattn/vim-lsp-settings'
	use 'neovim/nvim-lspconfig'
	use 'glepnir/lspsaga.nvim'

	-- Auto-complete
	use 'prabirshrestha/asyncomplete.vim'
	use 'prabirshrestha/asyncomplete-lsp.vim'
	use 'onsails/lspkind.nvim' -- VSCode like pictograms
	use 'L3MON4D3/LuaSnip'	-- Snippet engine

	-- Syntax highlightings
	use 'nvim-treesitter/nvim-treesitter'

	-- fuzzy finder over lists
	use 'nvim-lua/plenary.nvim'
	use 'nvim-telescope/telescope.nvim'

	-- bufferline
	use 'akinsho/nvim-bufferline.lua'

  -- Color scheme
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use 'folke/tokyonight.nvim'
	use 't9md/vim-quickhl'

	-- grep tool
	use 'rking/ag.vim'
	-- fzf
	use 'junegunn/fzf'
	use 'junegunn/fzf.vim'

	-- QuickRun
	use 'thinca/vim-quickrun'

	-- CoC
	use 'neoclide/coc.nvim'

	-- golang
	use 'mattn/vim-goimports'

	-- React
	use 'windwp/nvim-ts-autotag'	-- close tags quickly
	use 'windwp/nvim-autopairs'	-- for closing brackets

	-- HTML/JSX
	use 'mattn/emmet-vim'

	-- Code formatter
	use 'jose-elias-alvarez/null-ls.nvim'

	-- Run jest
	use 'mattkubej/jest.nvim'
end)

----------------------------------------------
--  General settings
----------------------------------------------
vim.opt.autoindent = true                    -- take indent for new line from previous line
vim.opt.smartindent = true                   -- enable smart indentation
vim.opt.autoread = true            -- reload file if the file changes on the disk
vim.opt.autowrite = true                    -- write when switching buffers
vim.opt.autowriteall= true                  -- write on :quit
vim.opt.colorcolumn='101'               -- highlight the 100th column as an indicator
vim.opt.completeopt= {"menuone", "preview", "noinsert" }          -- remove the horrendous preview window
vim.keymap.set('i', '<silent><expr> <CR>', 'coc#pum#visible() ? coc#pum#confirm() : "<CR>"')
vim.opt.encoding='utf-8'
vim.opt.expandtab= true                     -- expands tabs to spaces
vim.opt.list= true                          -- show trailing whitespace
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"
vim.opt.spell= false                       -- disable spelling
vim.opt.swapfile = true                    -- disable swapfile usage
vim.opt.wrap= false
vim.opt.errorbells= false                  -- No bells!
vim.opt.visualbell= false                  -- I said, no bells!
vim.opt.ruler= true                         -- show cursor position
vim.opt.formatoptions=tcqron          -- set vims text formatting options
vim.opt.softtabstop=2
vim.opt.tabstop=2
vim.opt.textwidth=100
vim.opt.title= true                         -- let vim set the terminal title
vim.opt.titlelen=95                   -- let vim set the terminal title
vim.opt.updatetime=100                -- redraw the status bar often
vim.opt.laststatus=2                  -- statusline height is 2
vim.opt.matchpairs = '(:),{:},[:],<:>'
vim.opt.cmdheight=2                   -- command line height
vim.opt.wildmenu= true                      -- enables a menu at the bottom
vim.opt.wildmode={'longest:full'}    -- do completion in the command line via tab
vim.opt.backspace=indent,eol,start    -- Enable backspace deletes indent and new line
vim.opt.clipboard = 'unnamedplus'            -- Share the clipboard between vim and Mac OS
vim.opt.syntax = 'off'

-- set the leader
vim.g.mapleader = ',' -- set the leader button

-- " Autosave buffers before leaving them
vim.api.nvim_create_autocmd({'BufLeave'}, {
        pattern = {'*'},
        command = 'silent! :wa'
})

-- Command mode keymappings
-- :h lua-keymap
vim.keymap.set('c', '<C-a>', '<Home>')
vim.keymap.set('c', '<C-b>', '<Left>')
vim.keymap.set('c', '<C-d>', '<Del>')
vim.keymap.set('c', '<C-e>', '<End>')
vim.keymap.set('c', '<C-f>', '<Right>')

-- easy escape
vim.keymap.set('i', 'jj', '<esc>')
-- go to last edited point
vim.keymap.set('n', ';l', '\'.')


-- jump to pair
vim.keymap.set('n', '<Tab>', '%')
vim.keymap.set('v', '<Tab>', '%')

-- show full path of file
vim.keymap.set('n', '<leader>fp', ':echo expand("%:p")<CR>')

-- insert mode keymaps like emacs
vim.keymap.set('i', '<C-p>', '<Up>')
vim.keymap.set('i', '<C-n>', '<Down>')
vim.keymap.set('i', '<C-b>', '<Left>')
vim.keymap.set('i', '<C-f>', '<Right>')
vim.keymap.set('i', '<C-e>', '<end>')
vim.keymap.set('i', '<C-d>', '<del>')
vim.keymap.set('i', '<C-h>', '<BS>')


----------------------------------------------
--  Colors
----------------------------------------------
vim.cmd[[colorscheme tokyonight]]

----------------------------------------------
--  Terminal mode
----------------------------------------------
-- Press ESC to NORMAL Mode
vim.keymap.set('t', '<esc>', '<C-\\><C-N>', {silent = true})
-- always INSERT MODE in open the terminal
vim.api.nvim_create_autocmd({'TermOpen'}, {
        pattern = {'*'},
        command = 'startinsert'
})


----------------------------------------------
-- Searching  
----------------------------------------------
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true

-- Clear search highlights
vim.keymap.set('n', '<Leader>c', ':nohlsearch<CR>')

-- These mappings will make it so that going to the next one in a search will
-- center on the line it's found in.
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

----------------------------------------------
-- Navigation
----------------------------------------------
-- Disable arrow keys
vim.keymap.set('n', '<Up>', '<NOP>')
vim.keymap.set('n', '<Down>', '<NOP>')
vim.keymap.set('n', '<Left>', '<NOP>')
vim.keymap.set('n', '<Right>', '<NOP>')

----------------------------------------------
-- Splits
----------------------------------------------
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Creating splits
vim.keymap.set('n', '<Leader>v', ':vsplit<CR>')
vim.keymap.set('n', '<Leader>h', ':split<CR>')

-- Move window
vim.keymap.set('n', 'sh', '<C-w>h')
vim.keymap.set('n', 'sk', '<C-w>k')
vim.keymap.set('n', 'sj', '<C-w>j')
vim.keymap.set('n', 'sl', '<C-w>l')

-- Close window splited
vim.keymap.set('n', '<leader>q', ':close<CR>')


----------------------------------------------
-- Plugin: QuickRun
----------------------------------------------
vim.keymap.set('n', '<Leader>r', ':QuickRun<enter>')

----------------------------------------------
-- Plugin: vim-quickhl
----------------------------------------------
vim.keymap.set('n', '<Leader>m', '<Plug>(quickhl-manual-this)')
vim.keymap.set('x', '<Leader>m', '<Plug>(quickhl-manual-this)')
vim.keymap.set('n', '<Leader>M', '<Plug>(quickhl-manual-reset)')
vim.keymap.set('x', '<Leader>M', '<Plug>(quickhl-manual-reset)')

----------------------------------------------
-- Plugin: mattkubej/jest.nvim
----------------------------------------------
vim.keymap.set('n', '<Leader>j', ':JestFile<CR>')

----------------------------------------------
-- Plugin: nvim-telescope/telescope.nvim
----------------------------------------------
vim.keymap.set('n', '<C-p>', ':Telescope git_files<CR>')
vim.keymap.set('n', '<Leader>ff', '<cmd>Telescope find_files<CR>')
vim.keymap.set('n', '<Leader>fg', '<cmd>Telescope live_grep<CR>')
vim.keymap.set('n', '<Leader>fb', '<cmd>Telescope buffers<CR>')
vim.keymap.set('n', '<Leader>fh', '<cmd>Telescope help_tags<CR>')

----------------------------------------------
-- Plugin: lualine.nvim
----------------------------------------------
require('lualine').setup {
        options = {
                icons_enabled = true,      
                theme = "auto",
        },
        sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = {'filename'},
                lualine_x = {'encoding', 'fileformat', 'filetype'},
                lualine_y = {'progress'},
                lualine_z = {'location'}
        },
        inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'filename'},
                lualine_x = {'location'},
                lualine_y = {},
                lualine_z = {}
        },

}

----------------------------------------------
-- Plugin: airblade/vim-gitgutter
----------------------------------------------
vim.cmd 'let g:gitgutter_max_signs = 1024'
vim.cmd 'let g:gitgutter_sign_added = "✚"'
vim.cmd 'let g:gitgutter_sign_modified = "➜"'
vim.cmd 'let g:gitgutter_sign_removed = "✘"'

----------------------------------------------
-- Plugin: coc
----------------------------------------------
vim.keymap.set('n', 'gd', '<Plug>(coc-definition)', {silent = true})
vim.keymap.set('n', 'gt', '<Plug>(coc-type-definition)', {silent = true})
vim.keymap.set('n', 'gi', '<Plug>(coc-implementation)', {silent = true})
vim.keymap.set('n', 'gr', '<Plug>(coc-references)', {silent = true})
vim.keymap.set('n', 'gds', ':sp<CR><Plug>(coc-definition)', {silent = true})
vim.keymap.set('n', 'gdv', ':vs<CR><Plug>(coc-definition)', {silent = true})

----------------------------------------------
-- Language: golang
----------------------------------------------

