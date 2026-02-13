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
        ensure_installed = {
          'ts_ls',       -- TypeScript/JavaScript/JSX/TSX
          'gopls',       -- Go
          'lua_ls',      -- Lua
          'rust_analyzer', -- Rust
          'pyright',     -- Python
          'html',        -- HTML
          'cssls',       -- CSS
          'biome',       -- Biome (JS/TS linter/formatter)
          'astro',       -- Astro
        },
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

      -- Rust
      vim.lsp.config.rust_analyzer = {
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            inlayHints = {
              parameterHints = { enable = true },
              typeHints = { enable = true },
            },
          },
        },
      }
      vim.lsp.enable('rust_analyzer')

      -- Python
      vim.lsp.config.pyright = {
        capabilities = capabilities,
      }
      vim.lsp.enable('pyright')

      -- HTML
      vim.lsp.config.html = {
        capabilities = capabilities,
      }
      vim.lsp.enable('html')

      -- CSS
      vim.lsp.config.cssls = {
        capabilities = capabilities,
      }
      vim.lsp.enable('cssls')

      -- Biome (JS/TS linter/formatter)
      vim.lsp.config.biome = {
        capabilities = capabilities,
      }
      vim.lsp.enable('biome')

      -- Astro
      vim.lsp.config.astro = {
        capabilities = capabilities,
      }
      vim.lsp.enable('astro')

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

          -- Inlay hints toggle
          vim.keymap.set('n', '<leader>ih', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, opts)

          -- Enable inlay hints by default
          if vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(true)
          end
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
        window = {
          completion = cmp.config.window.bordered({
            border = 'rounded',
            winhighlight = 'Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
          }),
          documentation = cmp.config.window.bordered({
            border = 'rounded',
            winhighlight = 'Normal:Pmenu,FloatBorder:FloatBorder',
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
      local langs = { 'lua', 'vim', 'vimdoc', 'javascript', 'typescript', 'tsx', 'go', 'html', 'css', 'json', 'yaml', 'markdown', 'rust', 'python', 'astro' }
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
    config = function()
      require('telescope').setup({
        defaults = {
          file_ignore_patterns = { '^.git/' },
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' },
          },
          live_grep = {
            additional_args = { '--hidden', '--glob', '!.git/' },
          },
        },
      })
    end,
    keys = {
      { '<C-p>', '<cmd>Telescope find_files<CR>' },
      { '<leader>ff', '<cmd>Telescope git_files<CR>' },
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
          javascript = { 'biome', 'prettier', stop_after_first = true },
          typescript = { 'biome', 'prettier', stop_after_first = true },
          typescriptreact = { 'biome', 'prettier', stop_after_first = true },
          javascriptreact = { 'biome', 'prettier', stop_after_first = true },
          json = { 'biome', 'prettier', stop_after_first = true },
          html = { 'prettier' },
          css = { 'prettier' },
          go = { 'goimports', 'gofmt' },
          lua = { 'stylua' },
          rust = { 'rustfmt' },
          python = { 'black' },
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
    end,
    keys = {
      { '<leader>]', '<cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
      { '<leader>[', '<cmd>BufferLineCyclePrev<CR>', desc = 'Prev buffer' },
      { '<leader>x', '<cmd>bdelete<CR>', desc = 'Close buffer' },
      { '<leader>1', '<cmd>BufferLineGoToBuffer 1<CR>' },
      { '<leader>2', '<cmd>BufferLineGoToBuffer 2<CR>' },
      { '<leader>3', '<cmd>BufferLineGoToBuffer 3<CR>' },
      { '<leader>4', '<cmd>BufferLineGoToBuffer 4<CR>' },
      { '<leader>5', '<cmd>BufferLineGoToBuffer 5<CR>' },
    },
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

  -- Which-key (show keybindings)
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      local wk = require('which-key')
      wk.setup({
        preset = 'modern',
        delay = 300,
        icons = {
          mappings = false,
        },
      })
      -- Register key groups
      wk.add({
        { '<leader>f', group = 'Find/File' },
        { '<leader>g', group = 'Git' },
        { '<leader>c', desc = 'Clear search highlight' },
        { '<leader>r', desc = 'QuickRun' },
        { '<leader>v', desc = 'Vertical split' },
        { '<leader>h', desc = 'Horizontal split' },
        { '<leader>q', desc = 'Close window' },
        { '<leader>x', desc = 'Close buffer' },
        { '<leader>m', desc = 'Highlight word' },
        { '<leader>M', desc = 'Clear highlights' },
        { '<leader>e', desc = 'Show diagnostic' },
        { '<leader>rn', desc = 'Rename symbol' },
        { '<leader>ca', desc = 'Code action' },
        { '<leader>ih', desc = 'Toggle inlay hints' },
        { '<leader>fp', desc = 'Show file path' },
        { '<leader>ff', desc = 'Find git files' },
        { '<leader>fg', desc = 'Live grep' },
        { '<leader>fb', desc = 'Find buffers' },
        { '<leader>fh', desc = 'Help tags' },
        { '<leader>gs', desc = 'Git status UI' },
        { '<leader>]', desc = 'Next buffer' },
        { '<leader>[', desc = 'Prev buffer' },
        { '<leader>1', desc = 'Buffer 1' },
        { '<leader>2', desc = 'Buffer 2' },
        { '<leader>3', desc = 'Buffer 3' },
        { '<leader>4', desc = 'Buffer 4' },
        { '<leader>5', desc = 'Buffer 5' },
      })
    end,
  },

  -- UI Enhancement
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    config = function()
      require('noice').setup({
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
          hover = {
            enabled = true,
            silent = true,
            view = nil,
            opts = {
              border = {
                style = 'rounded',
                padding = { 0, 1 },
              },
              position = { row = 2, col = 2 },
            },
          },
          signature = {
            enabled = true,
            opts = {
              border = {
                style = 'rounded',
                padding = { 0, 1 },
              },
            },
          },
          documentation = {
            view = 'hover',
            opts = {
              lang = 'markdown',
              replace = true,
              render = 'plain',
              format = { '{message}' },
              win_options = { concealcursor = 'n', conceallevel = 3 },
            },
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          lsp_doc_border = true,
        },
        views = {
          hover = {
            border = {
              style = 'rounded',
              padding = { 1, 2 },
            },
            win_options = {
              winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder',
            },
          },
        },
      })

      -- nvim-notify styling
      require('notify').setup({
        background_colour = '#292e42',
        stages = 'fade',
        timeout = 3000,
      })
    end,
  },
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
-- Float window styling
----------------------------------------------
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#292e42', fg = '#c0caf5' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = '#292e42', fg = '#7aa2f7' })

-- Completion menu styling
vim.api.nvim_set_hl(0, 'Pmenu', { bg = '#292e42', fg = '#c0caf5' })
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#3d4966', fg = '#c0caf5', bold = true })
vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = '#292e42' })
vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = '#7aa2f7' })


vim.diagnostic.config({
  float = {
    border = 'rounded',
    source = true,
  },
})

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

----------------------------------------------
-- Git Status UI (tig-like)
----------------------------------------------
local GitStatus = {}

function GitStatus.open()
  -- Get git status
  local output = vim.fn.systemlist('git status --porcelain 2>/dev/null')
  if vim.v.shell_error ~= 0 then
    vim.notify('Not a git repository', vim.log.levels.WARN)
    return
  end

  -- Get branch info
  local branch = vim.fn.system('git branch --show-current 2>/dev/null'):gsub('\n', '')
  local remote_status = vim.fn.system('git status -sb 2>/dev/null'):match('%[(.-)%]') or ''

  -- Parse status into categories
  local staged = {}
  local unstaged = {}
  local untracked = {}

  for _, line in ipairs(output) do
    if line ~= '' then
      local idx = line:sub(1, 1)  -- staged status
      local wt = line:sub(2, 2)   -- worktree status
      local file = line:sub(4)

      if line:sub(1, 2) == '??' then
        table.insert(untracked, { status = '?', file = file })
      else
        -- Staged changes (first column)
        if idx ~= ' ' and idx ~= '?' then
          table.insert(staged, { status = idx, file = file })
        end
        -- Unstaged changes (second column)
        if wt ~= ' ' and wt ~= '?' then
          table.insert(unstaged, { status = wt, file = file })
        end
      end
    end
  end

  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].filetype = 'gitstatus'

  -- Build display lines
  local lines = {}
  local file_map = {}  -- line number -> file info
  local first_file_line = nil

  -- Branch info
  local branch_line = 'On branch ' .. branch
  if remote_status ~= '' then
    branch_line = branch_line .. ' [' .. remote_status .. ']'
  end
  table.insert(lines, branch_line)
  table.insert(lines, '')

  -- Staged section
  table.insert(lines, 'Changes to be committed:')
  if #staged == 0 then
    table.insert(lines, '  (no files)')
  else
    for _, f in ipairs(staged) do
      table.insert(lines, '  ' .. f.status .. ' ' .. f.file)
      file_map[#lines] = { file = f.file, section = 'staged' }
      if not first_file_line then first_file_line = #lines end
    end
  end
  table.insert(lines, '')

  -- Unstaged section
  table.insert(lines, 'Changes not staged for commit:')
  if #unstaged == 0 then
    table.insert(lines, '  (no files)')
  else
    for _, f in ipairs(unstaged) do
      table.insert(lines, '  ' .. f.status .. ' ' .. f.file)
      file_map[#lines] = { file = f.file, section = 'unstaged' }
      if not first_file_line then first_file_line = #lines end
    end
  end
  table.insert(lines, '')

  -- Untracked section
  table.insert(lines, 'Untracked files:')
  if #untracked == 0 then
    table.insert(lines, '  (no files)')
  else
    for _, f in ipairs(untracked) do
      table.insert(lines, '  ' .. f.status .. ' ' .. f.file)
      file_map[#lines] = { file = f.file, section = 'untracked' }
      if not first_file_line then first_file_line = #lines end
    end
  end

  table.insert(lines, '')
  table.insert(lines, '[j/k] move  [Enter/d] diff  [u] stage/unstage  [C] commit  [q] close')

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  -- Window size
  local width = math.min(80, vim.o.columns - 4)
  local height = math.min(#lines + 2, vim.o.lines - 4)

  -- Open float window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = 'minimal',
    border = 'rounded',
    title = ' Git ',
    title_pos = 'center',
  })

  -- カーソル行をハイライト
  vim.wo[win].cursorline = true

  -- Highlighting
  vim.api.nvim_set_hl(0, 'GitStatusHeader', { fg = '#7aa2f7', bold = true })
  vim.api.nvim_set_hl(0, 'GitStatusStaged', { fg = '#9ece6a' })
  vim.api.nvim_set_hl(0, 'GitStatusUnstaged', { fg = '#e0af68' })
  vim.api.nvim_set_hl(0, 'GitStatusUntracked', { fg = '#f7768e' })
  vim.api.nvim_set_hl(0, 'GitStatusBranch', { fg = '#bb9af7' })

  local ns = vim.api.nvim_create_namespace('gitstatus')
  for i, line in ipairs(lines) do
    if line:match('^On branch') then
      vim.api.nvim_buf_add_highlight(buf, ns, 'GitStatusBranch', i - 1, 0, -1)
    elseif line:match('^Changes to be committed') then
      vim.api.nvim_buf_add_highlight(buf, ns, 'GitStatusHeader', i - 1, 0, -1)
    elseif line:match('^Changes not staged') then
      vim.api.nvim_buf_add_highlight(buf, ns, 'GitStatusHeader', i - 1, 0, -1)
    elseif line:match('^Untracked files') then
      vim.api.nvim_buf_add_highlight(buf, ns, 'GitStatusHeader', i - 1, 0, -1)
    elseif file_map[i] then
      local hl = ({
        staged = 'GitStatusStaged',
        unstaged = 'GitStatusUnstaged',
        untracked = 'GitStatusUntracked',
      })[file_map[i].section]
      vim.api.nvim_buf_add_highlight(buf, ns, hl, i - 1, 0, -1)
    end
  end

  -- Move cursor to first file
  if first_file_line then
    vim.api.nvim_win_set_cursor(win, { first_file_line, 0 })
  end

  -- Helper: get file under cursor
  local function get_current_file()
    local row = vim.api.nvim_win_get_cursor(win)[1]
    return file_map[row]
  end

  -- Helper: find next/prev file line
  local function find_file_line(start, direction)
    local row = start
    while row >= 1 and row <= #lines do
      row = row + direction
      if file_map[row] then return row end
    end
    return nil
  end

  -- Helper: refresh
  local function refresh()
    vim.api.nvim_win_close(win, true)
    GitStatus.open()
  end

  -- Keymaps
  local opts = { buffer = buf, silent = true, nowait = true }

  vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win, true) end, opts)
  vim.keymap.set('n', '<Esc>', function() vim.api.nvim_win_close(win, true) end, opts)

  vim.keymap.set('n', 'j', function()
    local row = vim.api.nvim_win_get_cursor(win)[1]
    local next = find_file_line(row, 1)
    if next then
      vim.api.nvim_win_set_cursor(win, { next, 0 })
    end
  end, opts)

  vim.keymap.set('n', 'k', function()
    local row = vim.api.nvim_win_get_cursor(win)[1]
    local prev = find_file_line(row, -1)
    if prev then
      vim.api.nvim_win_set_cursor(win, { prev, 0 })
    end
  end, opts)

  local function open_diff(f)
    vim.api.nvim_win_close(win, true)
    if f.section == 'untracked' then
      -- Untracked: プレビュー表示
      vim.cmd('view ' .. vim.fn.fnameescape(f.file))
    elseif f.section == 'staged' then
      vim.cmd('Git diff --cached ' .. vim.fn.fnameescape(f.file))
    else
      vim.cmd('Git diff ' .. vim.fn.fnameescape(f.file))
    end
    vim.keymap.set('n', 'q', function()
      vim.cmd('bdelete')
      vim.schedule(GitStatus.open)
    end, { buffer = true, silent = true })
  end

  vim.keymap.set('n', '<CR>', function()
    local f = get_current_file()
    if f then
      open_diff(f)
    end
  end, opts)

  vim.keymap.set('n', 'u', function()
    local f = get_current_file()
    if f then
      if f.section == 'staged' then
        vim.fn.system('git restore --staged ' .. vim.fn.shellescape(f.file))
      else
        vim.fn.system('git add ' .. vim.fn.shellescape(f.file))
      end
      refresh()
    end
  end, opts)

  vim.keymap.set('n', 'd', function()
    local f = get_current_file()
    if f then
      open_diff(f)
    end
  end, opts)

  vim.keymap.set('n', 'C', function()
    vim.api.nvim_win_close(win, true)
    vim.cmd('Git commit')
  end, opts)
end

vim.keymap.set('n', '<Leader>gs', GitStatus.open, { desc = 'Git status UI' })
