return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = false,
      },
    },
  },
  --   {
  --     'olimorris/codecompanion.nvim',
  --     opts = {},
  --     dependencies = {
  --       'nvim-lua/plenary.nvim',
  --       'nvim-treesitter/nvim-treesitter',
  --     },
  --   },
}
