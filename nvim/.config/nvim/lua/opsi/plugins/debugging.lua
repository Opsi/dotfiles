return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- for the dap-ui
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      -- adapter for go
      "leoluz/nvim-dap-go",
    },
    config = function()
      -- setting up the ui
      local dapui = require("dapui")
      local dap = require("dap")
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
      ---@diagnostic disable-next-line: missing-fields
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
        ---@diagnostic disable-next-line: missing-fields
        controls = {
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            step_back = "b",
            run_last = "▶▶",
            terminate = "⏹",
            disconnect = "⏏",
          },
        },
        floating = {
          border = "rounded",
          max_height = nil, -- These can be integers or a float between 0 and 1
          max_width = nil, -- Flood columns/rows if nil
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
      })

      -- setting up the go adapter
      require("dap-go").setup({
        delve = {
          -- I want to be able to debug integration and unit tests
          buildFlags = { "-tags=integration,unit" },
        },
      })

      -- setting up the keymaps
      local keymap = vim.keymap
      --- @type vim.keymap.set.Opts
      local opts = {}

      -- TODO: add what you need from this list

      opts.desc = "Toggle [b]reakpoint"
      keymap.set("n", "<leader>b", dap.toggle_breakpoint, opts)

      opts.desc = "Conditional [B]reakpoint"
      keymap.set("n", "<leader>B", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Debug: Set Breakpoint" })

      opts.desc = "Start / [c]ontinue"
      keymap.set("n", "<leader>dc", dap.continue, opts)

      opts.desc = "Step [o]ver"
      keymap.set("n", "<leader>do", dap.step_over, opts)

      opts.desc = "Step [i]nto"
      keymap.set("n", "<leader>di", dap.step_into, opts)

      opts.desc = "Step O[u]t"
      keymap.set("n", "<leader>du", dap.step_out, opts)

      opts.desc = "Step [b]ack"
      keymap.set("n", "<leader>db", dap.step_back, opts)

      opts.desc = "Open [r]EPL"
      keymap.set("n", "<leader>dr", dap.repl.open, opts)

      opts.desc = "Step [b]ack"
      keymap.set("n", "<leader>db", dap.step_back, opts)

      opts.desc = "[q]uit session"
      keymap.set("n", "<leader>dq", dap.terminate, opts)

      opts.desc = "Toggle Debug UI"
      keymap.set("n", "<leader>dv", dapui.toggle, opts)

      opts.desc = "[p]review marked expression"
      keymap.set({ "n", "v" }, "<Leader>dp", function()
        require("dap.ui.widgets").preview(nil, { border = "rounded" })
      end, opts)

      opts.desc = "Show [f]rames"
      keymap.set("n", "<Leader>df", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.frames, { border = "rounded" })
      end, opts)

      opts.desc = "Show [s]copes"
      keymap.set("n", "<Leader>ds", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.scopes, { border = "rounded" })
      end, opts)

      -- Change breakpoint icons
      vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
      vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })
      local breakpoint_icons = vim.g.have_nerd_font
          and { Breakpoint = "", BreakpointCondition = "", BreakpointRejected = "", LogPoint = "", Stopped = "" }
        or { Breakpoint = "●", BreakpointCondition = "⊜", BreakpointRejected = "⊘", LogPoint = "◆", Stopped = "⭔" }
      for type, icon in pairs(breakpoint_icons) do
        local tp = "Dap" .. type
        local hl = (type == "Stopped") and "DapStop" or "DapBreak"
        vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },
}
