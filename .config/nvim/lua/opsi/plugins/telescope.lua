return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      'folke/todo-comments.nvim',
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      local telescope = require 'telescope'
      telescope.setup {
        -- TODO: is this helping?
        path_display = { 'smart' },
        pickers = {
          find_files = {
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
          },
          live_grep = {
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            glob_pattern = '!**/.git/*',
            additional_args = { '--hidden' },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')
      pcall(telescope.load_extension, 'noice')

      -- See `:help telescope.builtin`
      local keymap = vim.keymap
      local builtin = require 'telescope.builtin'
      keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[f]ind [f]iles' })
      keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'find[ ]buffers' })
      keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[f]ind by [g]rep' })
      keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[f]earch [k]eymaps' })
      keymap.set('n', '<leader>fc', builtin.grep_string, { desc = '[f]ind string under [c]ursor' })
      keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[f]ind [h]elp tags' })
      keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = '[f]ind [s]ymbols' })
      keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = '[f]ind [r]ecent files' })
      keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[f]ind [k]eymaps' })
      keymap.set('n', '<leader>ft', '<cmd>TodoTelescope<cr>', { desc = '[f]ind [t]odos' })

      keymap.set('n', '<leader>gc', builtin.git_commits, { desc = '[f]ind in [g]it [c]ommits' })
      keymap.set('n', '<leader>gb', builtin.git_bcommits, { desc = '[f]ind [g]it Commits for [b]uffer' })

      -- Find git status files (changed, new, etc.)
      keymap.set('n', '<leader>gs', require('telescope.builtin').git_status, { desc = '[g]it [s]tatus files' })
      -- keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[f]ind in [d]iagnostics' })

      -- Slightly advanced example of overriding default behavior and theme
      keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      -- keymap.set('n', '<leader>s/', function()
      --   builtin.live_grep {
      --     grep_open_files = true,
      --     prompt_title = 'Live Grep in Open Files',
      --   }
      -- end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      keymap.set('n', '<leader>fn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[f]ind [n]eovim files' })
    end,
  },
}
