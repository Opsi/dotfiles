return {
  {
    -- installs LSPs, DAPs, linters and formatters
    "williamboman/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✔",
          package_pending = "➜",
          package_uninstalled = "🗙",
        },
      },
    },
  },
  {
    -- helps with giving the LPSs a proper default configuration
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim" },
  },
  {
    -- this is used to automate the configuration of language
    -- servers (installed via mason)
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "bashls",
        "dockerls",
        "yamlls",
        "basedpyright",
        "biome",
        "emmet_language_server",
        "gopls",
        "lua_ls",
        "rust_analyzer",
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt = true,
            buildFlags = { "-tags=integration,unit" },
            analyses = { unusedparams = true },
          },
        },
      })

      vim.lsp.config("lua_ls", {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".git" },
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })

      -- 3. Enable all servers in your ensure_installed list
      for _, server in ipairs(opts.ensure_installed) do
        vim.lsp.enable(server)
      end
    end,
  },
  {
    -- this one installs the non-LSP things (via mason)
    -- like formatters, DAPs and linters
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
        "pylint",
        "eslint_d",
        "delve", -- for golang debugging
        "gofumpt", -- for golang formatting
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
}
