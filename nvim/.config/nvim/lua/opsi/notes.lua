-- Markdown notes: journal + zettelkasten
local M = {}

M.root = vim.fn.expand("~/projects/secondbrain/vault/zettelkasten")
M.journal_dir = M.root .. "/logs"
M.zettel_dir = M.root

-- open path; if it doesn't exist, fill an unsaved buffer with `lines` (written on :w)
local function open_or_create(path, lines)
  local exists = vim.uv.fs_stat(path) ~= nil
  vim.cmd.edit(vim.fn.fnameescape(path))
  if not exists and vim.api.nvim_buf_line_count(0) == 1 and vim.api.nvim_get_current_line() == "" then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.bo.modified = true
  end
end

local function journal(offset_days)
  local date = os.date("%Y-%m-%d", os.time() + offset_days * 86400)
  local path = M.journal_dir .. "/" .. date .. ".md"
  local lines = { "# " .. date }
  local template = M.journal_dir .. "/template.md"
  if vim.uv.fs_stat(template) then
    lines = vim.fn.readfile(template)
    for i, l in ipairs(lines) do
      lines[i] = l:gsub("{{date}}", date)
    end
  end
  open_or_create(path, lines)
end

local function slugify(title)
  local s = title:lower()
  for from, to in pairs({ ["ä"] = "ae", ["ö"] = "oe", ["ü"] = "ue", ["ß"] = "ss" }) do
    s = s:gsub(from, to)
  end
  s = s:gsub("[^%w]+", "_"):gsub("^_+", ""):gsub("_+$", "")
  return s
end

local function new_note()
  vim.ui.input({ prompt = "Note title: " }, function(title)
    if not title or vim.trim(title) == "" then
      return
    end
    title = vim.trim(title)
    local path = M.zettel_dir .. "/" .. slugify(title) .. ".md"
    open_or_create(path, {
      "---",
      "is_definition: false",
      "acronym:",
      "---",
      "",
      "# " .. title,
      "",
      "",
    })
  end)
end

local map = vim.keymap.set
map("n", "<leader>zh", function()
  journal(0)
end, { desc = "[z]ettel journal [h]eute" })
map("n", "<leader>zm", function()
  journal(1)
end, { desc = "[z]ettel journal [m]orgen" })
map("n", "<leader>zn", new_note, { desc = "[z]ettel [n]ew note" })
map("n", "<leader>zf", function()
  require("telescope.builtin").find_files({ cwd = M.root })
end, { desc = "[z]ettel [f]ind notes" })
map("n", "<leader>zg", function()
  require("telescope.builtin").live_grep({ cwd = M.root })
end, { desc = "[z]ettel [g]rep notes" })

return M
