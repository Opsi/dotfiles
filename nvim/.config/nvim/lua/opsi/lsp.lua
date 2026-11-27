vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", {}),
  callback = function(ev)
    local keymap = vim.keymap
    local opts = { buffer = ev.buf, silent = true }

    -- prefer LSP folding over treesitter when the server supports it
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/foldingRange") then
      vim.wo[0][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end

    opts.desc = "[g]oto [R]eferences"
    keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

    opts.desc = "[g]oto [D]eclaration"
    keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

    opts.desc = "[g]oto [d]efinition"
    keymap.set("n", "gd", vim.lsp.buf.definition, opts)

    opts.desc = "[g]oto [i]mplementation"
    keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

    opts.desc = "[g]oto [t]ype definition"
    keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

    opts.desc = "[c]ode [a]ctions"
    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

    opts.desc = "[r]e[n]ame"
    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

    opts.desc = "[t]oggle Inlay [h]ints"
    keymap.set("n", "<leader>th", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }))
    end, opts)

    opts.desc = "[c]ode [o]rganize Imports"
    keymap.set("n", "<leader>co", function()
      -- TODO: is this still used?
      vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" } },
        apply = true,
      })
    end, opts)

    -- TODO: find out if this can be moved to telescope or if the document symbol function from
    -- telescope needs to be moved here

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    opts.desc = "Open Workspace Symbols"
    keymap.set("n", "gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, opts)

    opts.desc = "[r]e[s]tart LSP"
    keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
  end,
})

-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config({
  severity_sort = true,
  jump = { float = true }, -- ]d / [d open the diagnostic float
  float = { source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  } or {},
  virtual_text = {
    source = "if_many",
    spacing = 2,
  },
})
