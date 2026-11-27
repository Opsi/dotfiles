return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Everything is one WIDTH-wide block: centered as a whole,
    -- left-aligned inside (every line padded to WIDTH)
    local WIDTH = 50
    local ACCENT = "Green" -- tags + banner ("Red" to compare)

    local function pad(s)
      return s .. string.rep(" ", math.max(0, WIDTH - vim.fn.strdisplaywidth(s)))
    end

    -- keep the tail of s if it is wider than room ("…/plugins/")
    local function truncate_left(s, room)
      if vim.fn.strdisplaywidth(s) <= room then
        return s
      end
      if room <= 1 then
        return ""
      end
      return "…" .. vim.fn.strcharpart(s, vim.fn.strchars(s) - room + 1)
    end

    local function text(val, hl)
      return { type = "text", val = val, opts = { position = "center", hl = hl } }
    end

    local function group(val)
      return { type = "group", val = val, opts = { spacing = 0 } }
    end

    -- Banner, padded like the rest so it sits left-aligned in the block
    local BANNER = {
      "██╗███╗   ██╗ ██████╗ ███████╗███╗   ██╗",
      "██║████╗  ██║██╔════╝ ██╔════╝████╗  ██║",
      "██║██╔██╗ ██║██║  ███╗█████╗  ██╔██╗ ██║",
      "██║██║╚██╗██║██║   ██║██╔══╝  ██║╚██╗██║",
      "██║██║ ╚████║╚██████╔╝███████╗██║ ╚████║",
      "╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝",
    }
    local banner = text(vim.tbl_map(pad, BANNER), ACCENT)

    -- "[tag] value" log line, red tag
    local function log_line(tag, value, value_hl)
      local head = "[" .. tag .. "] "
      value = truncate_left(value, WIDTH - #head)
      local hl = { { ACCENT, 1, 1 + #tag } }
      if value_hl then
        table.insert(hl, { value_hl, #head, #head + #value })
      end
      return pad(head .. value), hl
    end

    local function log_el(tag, value, value_hl)
      return text(log_line(tag, value, value_hl))
    end

    -- Boot log
    local boot_log = group({
      log_el("init", "ingen systems // isla nublar"),
      log_el("cwd", vim.fn.fnamemodify(vim.fn.getcwd(), ":~")),
      log_el("date", os.date("%Y-%m-%d %H:%M")),
      log_el("status", "all systems nominal"),
    })

    -- Menu: "<prefix>[key] label", red key, cursor on key.
    -- alpha treats opts.cursor as a display column, hence strdisplaywidth.
    local function button(sc, prefix, key, label, cmd)
      local b = dashboard.button(sc, pad(prefix .. "[" .. key .. "] " .. label), cmd)
      b.opts.shortcut = nil -- no shortcut column, keymap stays
      b.opts.hl_shortcut = nil
      b.opts.width = WIDTH
      b.opts.cursor = vim.fn.strdisplaywidth(prefix) + 1
      b.opts.hl = { { ACCENT, #prefix + 1, #prefix + 1 + #key } }
      return b
    end

    local function tree_header(tag)
      return text(pad("[" .. tag .. "]"), { { ACCENT, 1, 1 + #tag } })
    end

    local MID, LAST = " ├─", " └─"

    -- Specimens: recent files (cwd first, global fallback)
    local MAX_SPECIMENS = 5

    local function is_specimen(path)
      if vim.fn.filereadable(path) == 0 then
        return false
      end
      local name = vim.fn.fnamemodify(path, ":t")
      if name == "COMMIT_EDITMSG" or name == "MERGE_MSG" or name == "git-rebase-todo" then
        return false
      end
      return not path:match("/doc/[^/]+%.txt$")
    end

    local function recent_files(max)
      local cwd = vim.fn.getcwd() .. "/"
      local local_files, global_files = {}, {}
      for _, path in ipairs(vim.v.oldfiles) do
        if is_specimen(path) then
          if vim.startswith(path, cwd) then
            table.insert(local_files, path)
          end
          if #global_files < max then
            table.insert(global_files, path)
          end
          if #local_files >= max then
            break
          end
        end
      end
      local files = #local_files > 0 and local_files or global_files
      return vim.list_slice(files, 1, max)
    end

    local function specimen_button(i, path, prefix)
      local key = tostring(i)
      local name = vim.fn.fnamemodify(path, ":t")
      local dir = vim.fn.fnamemodify(path, ":~:.:h")
      dir = dir == "." and "" or dir

      local head = prefix .. "[" .. key .. "] " .. name .. " "
      dir = truncate_left(dir, WIDTH - vim.fn.strdisplaywidth(head))

      local b = button(key, prefix, key, name .. " " .. dir, "<cmd>e " .. vim.fn.fnameescape(path) .. "<CR>")
      table.insert(b.opts.hl, { "Grey", #head, #head + #dir })
      return b
    end

    local menu = {
      button("e", "", "e", "new file", "<cmd>ene<CR>"),
      button("-", "", "-", "navigate", "<cmd>Oil<CR>"),
      tree_header("space"),
      button("SPC ff", MID, "ff", "scan", "<cmd>Telescope find_files<CR>"),
      button("SPC fg", MID, "fg", "grep", "<cmd>Telescope live_grep<CR>"),
      button("SPC wr", LAST, "wr", "restore", "<cmd>lua require('opsi.sessions').restore()<CR>"),
    }
    local files = recent_files(MAX_SPECIMENS)
    if #files > 0 then
      table.insert(menu, tree_header("cold storage"))
      for i, path in ipairs(files) do
        table.insert(menu, specimen_button(i, path, i == #files and LAST or MID))
      end
    end
    table.insert(menu, button("q", "", "q", "shutdown", "<cmd>qa<CR>"))

    -- Footer: lazy stats, refreshed once lazy.nvim reports startup time
    local fences = log_el("fences", "online", "Grey")
    local modules = log_el("modules", "", "Grey")
    local boot = log_el("boot", "", "Grey")

    local function update_stats()
      local stats = require("lazy").stats()
      modules.val, modules.opts.hl = log_line("modules", string.format("%d/%d", stats.loaded, stats.count), "Grey")
      boot.val, boot.opts.hl = log_line("boot", string.format("%dms", math.floor(stats.startuptime + 0.5)), "Grey")
    end
    update_stats()

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      once = true,
      callback = function()
        update_stats()
        pcall(vim.cmd.AlphaRedraw)
      end,
    })

    -- Layout: banner -> boot log -> menu (incl. specimens) -> footer
    dashboard.config.layout = {
      { type = "padding", val = 2 },
      banner,
      { type = "padding", val = 2 },
      boot_log,
      { type = "padding", val = 1 },
      group(menu),
      { type = "padding", val = 1 },
      group({ fences, modules, boot }),
    }

    -- Send config to alpha
    alpha.setup(dashboard.config)

    -- Disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
