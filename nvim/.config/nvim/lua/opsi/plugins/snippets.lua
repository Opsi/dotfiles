return {
  "L3MON4D3/LuaSnip",
  -- follow latest release.
  version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  -- install jsregexp (optional!).
  build = "make install_jsregexp",
  config = function()
    local ls = require("luasnip")
    ls.setup({ enable_autosnippets = true })

    -- keymaps
    vim.keymap.set({ "i", "s" }, "<Tab>", function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
      end
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<C-n>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { silent = true })

    -- snippets
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local fmt = require("luasnip.extras.fmt").fmt

    ls.add_snippets("go", {
      s(
        "fn",
        fmt("func {}({}) {} {{\n\t{}\n}}", {
          i(1, "name"),
          i(2),
          i(3),
          i(0),
        })
      ),
      s(
        "str",
        fmt("type {} struct {{\n\t{}\n}}", {
          i(1, "name"),
          i(0),
        })
      ),
      s(
        "ife",
        fmt("if err != nil {{\n\t{}\n}}", {
          i(0),
        })
      ),
    })

    ls.add_snippets("", {
      -- your rust snippets
    })

    -- etc.
  end,
}
