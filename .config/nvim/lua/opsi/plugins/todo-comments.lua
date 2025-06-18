return {
  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local todo_comments = require 'todo-comments'
      local keymap = vim.keymap
      keymap.set('n', ']t', function()
        todo_comments.jump_next()
      end, { desc = 'Next todo comment' })

      keymap.set('n', '[t', function()
        todo_comments.jump_prev()
      end, { desc = 'Previous todo comment' })

      todo_comments.setup {
        signs = true,
      }
    end,
  },
}
