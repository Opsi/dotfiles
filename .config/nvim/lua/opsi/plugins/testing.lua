return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- adapters need to be added here and in the config function
      {
        "fredrikaverpil/neotest-golang",
        build = function()
          vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait() -- Optional, but recommended
        end,
      },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-golang")({
            go_test_args = { "-v", "-race", "-count=1" },
            dap_go_enabled = true, -- Integration with nvim-dap-go
          }),
          -- require("neotest-golang")({
          --   -- runner = "gotestsum",
          --   runner = "go",
          -- }),
        },
      })
    end,
    keys = {
      {
        "<leader>tr",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest Test",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run File",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true })
        end,
        desc = "Show Output",
      },
    },
  },
}
