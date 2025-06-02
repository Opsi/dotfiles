return {
  {
    'catppuccin/nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    opts = {
      transparent_background = true,
    },
    config = function()
      vim.cmd.colorscheme 'catppuccin-frappe'
    end,
  },
  { 'nyoom-engineering/oxocarbon.nvim' },
  {
    'tokyonight.nvim',
    opts = {
      transparent = true,
      styles = {
        sidebars = 'transparent',
        floats = 'transparent',
      },
    },
  },
}
