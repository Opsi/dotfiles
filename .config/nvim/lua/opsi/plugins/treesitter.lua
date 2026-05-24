return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  branch = "main",
  build = ":TSUpdate",
  init = function()
    local ts = require("nvim-treesitter")
    local ensureInstalled = {
      "astro",
      "bash",
      "bash",
      "c",
      "css",
      "diff",
      "dockerfile",
      "gdscript",
      "gdshader",
      "gitignore",
      "go",
      "gomod",
      "gowork",
      "gosum",
      "godot_resource",
      "graphql",
      "html",
      "javascript",
      "json",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "prisma",
      "python",
      "query",
      "regex",
      "rust",
      "svelte",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    }
    local alreadyInstalled = require("nvim-treesitter.config").get_installed()
    local parsersToInstall = vim
      .iter(ensureInstalled)
      :filter(function(parser)
        return not vim.tbl_contains(alreadyInstalled, parser)
      end)
      :totable()
    ts.install(parsersToInstall)

    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        -- Enable treesitter highlighting and disable regex syntax
        pcall(vim.treesitter.start)
        -- Enable treesitter-based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
  -- config = function()
  --   -- import nvim-treesitter plugin
  --   local ts = require("nvim-treesitter")
  --
  --   ts.install({
  --     "astro",
  --     "bash",
  --     "bash",
  --     "c",
  --     "css",
  --     "diff",
  --     "dockerfile",
  --     "gdscript",
  --     "gdshader",
  --     "gitignore",
  --     "go",
  --     "gomod",
  --     "gowork",
  --     "gosum",
  --     "godot_resource",
  --     "graphql",
  --     "html",
  --     "javascript",
  --     "json",
  --     "lua",
  --     "luadoc",
  --     "markdown",
  --     "markdown_inline",
  --     "prisma",
  --     "python",
  --     "query",
  --     "regex",
  --     "rust",
  --     "svelte",
  --     "tsx",
  --     "typescript",
  --     "vim",
  --     "vimdoc",
  --     "yaml",
  --   })

  -- configure treesitter
  -- ts.setup({ -- enable syntax highlighting
  --   highlight = {
  --     enable = true,
  --   },
  --   -- enable indentation
  --   indent = { enable = true },
  --   incremental_selection = {
  --     enable = true,
  --     keymaps = {
  --       init_selection = "<C-space>",
  --       node_incremental = "<C-space>",
  --       scope_incremental = false,
  --       node_decremental = "<bs>",
  --     },
  --   },
  -- })
  -- end,
}
