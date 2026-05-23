local keymap = vim.keymap
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    opts.desc = '[g]oto [R]eferences'
    keymap.set('n', 'gR', '<cmd>Telescope lsp_references<CR>', opts)

    opts.desc = '[g]oto [D]eclaration'
    keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

    opts.desc = '[g]oto [d]efinition'
    keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

    opts.desc = '[g]oto [i]mplementation'
    keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)

    opts.desc = '[g]oto [t]ype definition'
    keymap.set('n', 'gt', '<cmd>Telescope lsp_type_definitions<CR>', opts)

    opts.desc = '[c]ode [a]ctions'
    keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)

    opts.desc = '[r]e[n]ame'
    keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

    opts.desc = 'Show line diagnostics'
    keymap.set('n', 'gl', vim.diagnostic.open_float, opts)

    opts.desc = '[t]oggle Inlay [h]ints'
    keymap.set('n', '<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = ev.buf })
    end, opts)

    opts.desc = '[c]ode [o]rganize Imports'
    keymap.set('n', '<leader>co', function()
      -- TODO: is this still used?
      vim.lsp.buf.code_action {
        context = { only = { 'source.organizeImports' } },
        apply = true,
      }
    end, opts)

    -- TODO: find out if this can be moved to telescope or if the document symbol function from
    -- telescope needs to be moved here

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    opts.desc = 'Open Workspace Symbols'
    keymap.set('n', 'gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, opts)

    opts.desc = '[r]e[s]tart LSP'
    keymap.set('n', '<leader>rs', ':LspRestart<CR>', opts)

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, ev.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = ev.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = ev.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end
  end,
})

-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
}
