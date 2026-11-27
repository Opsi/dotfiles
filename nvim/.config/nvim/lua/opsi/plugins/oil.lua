local detail = false

return {
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      view_options = {
        show_hidden = true,
      },
      win_options = {
        -- room for oil-git-status (index + worktree)
        signcolumn = "yes:2",
      },
      lsp_file_methods = {
        -- save LSP-refactored buffers unless they had unsaved changes before
        autosave_changes = "unmodified",
      },
      keymaps = {
        -- keep window navigation from core/keymaps.lua
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-s>"] = false,
        ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open in vertical split" },
        ["<C-x>"] = { "actions.select", opts = { horizontal = true }, desc = "Open in horizontal split" },
        ["R"] = "actions.refresh",
        ["gd"] = {
          desc = "Toggle file details",
          callback = function()
            detail = not detail
            if detail then
              require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
            else
              require("oil").set_columns({ "icon" })
            end
          end,
        },
        ["gX"] = {
          desc = "Discard all changes",
          callback = function()
            if vim.fn.confirm("Discard all Oil changes?", "&Yes\n&No", 2) == 1 then
              require("oil").discard_all_changes()
            end
          end,
        },
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Oil (parent dir)" },
      { "<leader>-", "<CMD>Oil --float<CR>", desc = "Oil (float)" },
    },
  },
  {
    "refractalize/oil-git-status.nvim",
    dependencies = { "stevearc/oil.nvim" },
    config = true,
  },
}
