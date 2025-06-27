return {
  {
    'ribru17/bamboo.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('bamboo').setup {
        style = 'multiplex',
        transparent = false,
      }
      require('bamboo').load()
    end,
  },
  -- {
  --   'catppuccin/nvim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   opts = {
  --     transparent_background = true,
  --   },
  --   config = function()
  --     vim.cmd.colorscheme 'catppuccin-frappe'
  --   end,
  -- },
  -- {
  --   'everviolet/nvim',
  --   name = 'evergarden',
  --   priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
  --   opts = {
  --     theme = {
  --       variant = 'fall', -- 'winter'|'fall'|'spring'|'summer'
  --       accent = 'green',
  --     },
  --     editor = {
  --       transparent_background = false,
  --       sign = { color = 'none' },
  --       float = {
  --         color = 'mantle',
  --         invert_border = false,
  --       },
  --       completion = {
  --         color = 'surface0',
  --       },
  --     },
  --   },
  -- },

  -- { 'comfysage/twilight-moon' },
  -- { 'rebelot/kanagawa.nvim' },
  -- { 'nyoom-engineering/oxocarbon.nvim' },
  -- {
  --   'tokyonight.nvim',
  --   opts = {
  --     transparent = true,
  --     styles = {
  --       sidebars = 'transparent',
  --       floats = 'transparent',
  --     },
  --   },
  -- },
  -- {
  --   'jesseleite/nvim-noirbuddy',
  --   dependencies = {
  --     { 'tjdevries/colorbuddy.nvim' },
  --   },
  --   opts = {
  --     -- All of your `setup(opts)` will go here
  --   },
  -- },
  -- {
  --   'sainnhe/everforest',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     -- Optionally configure and load the colorscheme
  --     -- directly inside the plugin declaration.
  --     vim.g.everforest_enable_italic = '1'
  --     vim.g.everforest_background = 'hard'
  --   end,
  -- },
}
