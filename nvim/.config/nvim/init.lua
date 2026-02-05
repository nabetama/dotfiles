----------------------------------------------
-- Bootstrap lazy.nvim
----------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader before lazy
vim.g.mapleader = ','

----------------------------------------------
-- Plugins
----------------------------------------------
require("lazy").setup({
  -- Git
  'tpope/vim-fugitive',
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        signs = {
          add          = { text = '✚' },
          change       = { text = '➜' },
          delete       = { text = '✘' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
        },
      })
    end
  },

  -- LSP
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = { 'ts_ls', 'gopls', 'lua_ls' },
      })
    end
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- TypeScript
      vim.lsp.config.ts_ls = {
        capabilities = capabilities,
      }
      vim.lsp.enable('ts_ls')

      -- Go
      vim.lsp.config.gopls = {
        capabilities = capabilities,
      }
      vim.lsp.enable('gopls')

      -- Lua
      vim.lsp.config.lua_ls = {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
          },
        },
      }
      vim.lsp.enable('lua_ls')

      -- LSP keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local opts = { buffer = args.buf, silent = true }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
        end,
      })
    end
  },

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind.nvim',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local lspkind = require('lspkind')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
          }),
        },
      })
    end
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      -- Neovim 0.11+ uses vim.treesitter directly
      local langs = { 'lua', 'vim', 'vimdoc', 'javascript', 'typescript', 'tsx', 'go', 'html', 'css', 'json', 'yaml', 'markdown' }
      for _, lang in ipairs(langs) do
        pcall(function()
          vim.treesitter.language.add(lang)
        end)
      end
      -- Enable treesitter-based highlighting
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end
  },

  -- Autopairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup()
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end
  },

  -- Autotag for HTML/JSX
  { 'windwp/nvim-ts-autotag' },

  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<C-p>', '<cmd>Telescope git_files<CR>' },
      { '<leader>ff', '<cmd>Telescope find_files<CR>' },
      { '<leader>fg', '<cmd>Telescope live_grep<CR>' },
      { '<leader>fb', '<cmd>Telescope buffers<CR>' },
      { '<leader>fh', '<cmd>Telescope help_tags<CR>' },
    },
  },

  -- Formatter & Linter
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          javascript = { 'prettier' },
          typescript = { 'prettier' },
          typescriptreact = { 'prettier' },
          javascriptreact = { 'prettier' },
          json = { 'prettier' },
          html = { 'prettier' },
          css = { 'prettier' },
          go = { 'goimports', 'gofmt' },
          lua = { 'stylua' },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end
  },

  -- UI
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          icons_enabled = true,
          theme = 'auto',
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
      })
    end
  },
  { 'nvim-tree/nvim-web-devicons' },
  {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('bufferline').setup()
    end
  },

  -- Color scheme
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end
  },

  -- Misc
  { 't9md/vim-quickhl' },
  { 'thinca/vim-quickrun' },
  { 'mattn/emmet-vim' },
})

----------------------------------------------
-- General settings
----------------------------------------------
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.autowriteall = true
vim.opt.colorcolumn = '101'
vim.opt.completeopt = { 'menuone', 'noselect' }
vim.opt.encoding = 'utf-8'
vim.opt.expandtab = true
vim.opt.list = true
vim.opt.listchars:append('space:⋅')
vim.opt.listchars:append('eol:↴')
vim.opt.spell = false
vim.opt.swapfile = false
vim.opt.wrap = false
vim.opt.errorbells = false
vim.opt.visualbell = false
vim.opt.ruler = true
vim.opt.formatoptions = 'tcqron'
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.textwidth = 100
vim.opt.title = true
vim.opt.titlelen = 95
vim.opt.updatetime = 100
vim.opt.laststatus = 2
vim.opt.matchpairs = '(:),{:},[:],<:>'
vim.opt.cmdheight = 2
vim.opt.wildmenu = true
vim.opt.wildmode = { 'longest:full' }
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.clipboard = 'unnamedplus'
vim.opt.number = true
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true

----------------------------------------------
-- Autosave
----------------------------------------------
vim.api.nvim_create_autocmd({ 'BufLeave' }, {
  pattern = { '*' },
  command = 'silent! :wa',
})

----------------------------------------------
-- Keymaps: Command mode (emacs-like)
----------------------------------------------
vim.keymap.set('c', '<C-a>', '<Home>')
vim.keymap.set('c', '<C-b>', '<Left>')
vim.keymap.set('c', '<C-d>', '<Del>')
vim.keymap.set('c', '<C-e>', '<End>')
vim.keymap.set('c', '<C-f>', '<Right>')

----------------------------------------------
-- Keymaps: Insert mode
----------------------------------------------
vim.keymap.set('i', 'jj', '<Esc>')
vim.keymap.set('i', '<C-p>', '<Up>')
vim.keymap.set('i', '<C-n>', '<Down>')
vim.keymap.set('i', '<C-b>', '<Left>')
vim.keymap.set('i', '<C-f>', '<Right>')
vim.keymap.set('i', '<C-e>', '<End>')
vim.keymap.set('i', '<C-d>', '<Del>')
vim.keymap.set('i', '<C-h>', '<BS>')

----------------------------------------------
-- Keymaps: Normal mode
----------------------------------------------
vim.keymap.set('n', ';l', "'.")
vim.keymap.set('n', '<Tab>', '%')
vim.keymap.set('v', '<Tab>', '%')
vim.keymap.set('n', '<leader>fp', ':echo expand("%:p")<CR>')

-- Searching
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.keymap.set('n', '<Leader>c', ':nohlsearch<CR>')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

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
vim.keymap.set('n', '<Leader>v', ':vsplit<CR>')
vim.keymap.set('n', '<Leader>h', ':split<CR>')
vim.keymap.set('n', 'sh', '<C-w>h')
vim.keymap.set('n', 'sk', '<C-w>k')
vim.keymap.set('n', 'sj', '<C-w>j')
vim.keymap.set('n', 'sl', '<C-w>l')
vim.keymap.set('n', '<leader>q', ':close<CR>')

----------------------------------------------
-- Terminal mode
----------------------------------------------
vim.keymap.set('t', '<Esc>', '<C-\\><C-N>', { silent = true })
vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  pattern = { '*' },
  command = 'startinsert',
})

----------------------------------------------
-- Plugin keymaps
----------------------------------------------
-- QuickRun
vim.keymap.set('n', '<Leader>r', ':QuickRun<CR>')

-- vim-quickhl
vim.keymap.set('n', '<Leader>m', '<Plug>(quickhl-manual-this)')
vim.keymap.set('x', '<Leader>m', '<Plug>(quickhl-manual-this)')
vim.keymap.set('n', '<Leader>M', '<Plug>(quickhl-manual-reset)')
vim.keymap.set('x', '<Leader>M', '<Plug>(quickhl-manual-reset)')
