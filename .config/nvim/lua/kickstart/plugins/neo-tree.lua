-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '<leader>e', ':Neotree reveal right<CR>', desc = '[E]xplorer', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        position = 'right',
        mappings = {
          ['e'] = 'close_window',
        },
      },
    },
  },
}
