return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
    opts = {
      bullet = {
        -- rainbow bullets: cycles through heading colors per nesting level
        highlight = {
          "RenderMarkdownH1",
          "RenderMarkdownH2",
          "RenderMarkdownH3",
          "RenderMarkdownH4",
          "RenderMarkdownH5",
          "RenderMarkdownH6",
        },
      },
      -- checkboxes are rendered by checkmate
      checkbox = { enabled = false },
    },
  },
  {
    "bngarren/checkmate.nvim",
    ft = "markdown",
    opts = {
      files = { "*.md" },
      linter = { enabled = false },
      list_continuation = {
        keys = {
          ["<CR>"] = function()
            require("checkmate").create({ position = "below", indent = false })
          end,
          ["<C-CR>"] = function()
            require("checkmate").create({ position = "below", indent = true })
          end,
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("opsi-markdown", {}),
        pattern = "markdown",
        callback = function(ev)
          -- ftplugin defaults to 4; keeps <C-t>/<C-d> consistent with 2-space nested lists
          vim.opt_local.shiftwidth = 2
          vim.keymap.set({ "n", "i" }, "<C-Space>", function()
            require("checkmate").toggle()
          end, { buffer = ev.buf, desc = "Toggle todo item" })
        end,
      })
    end,
  },
}
