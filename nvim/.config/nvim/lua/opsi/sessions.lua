-- Minimal session management (replaces auto-session).
-- Sessions live in the same dir / use the same file naming as auto-session, so old sessions keep working.
local M = {}

M.dir = vim.fn.stdpath("data") .. "/sessions/"
-- never auto-save sessions in these dirs
M.suppress_dirs = { "~/", "~/src", "~/projects", "~/Downloads", "~/Documents", "~/Desktop/" }

local function session_file()
  local cwd = vim.fn.getcwd()
  local encoded = cwd:gsub("[^%w%-_]", function(c)
    return string.format("%%%02X", c:byte())
  end)
  return M.dir .. encoded .. ".vim"
end

local function is_suppressed()
  local cwd = vim.fn.getcwd()
  for _, d in ipairs(M.suppress_dirs) do
    if vim.fs.normalize(vim.fn.expand(d)) == cwd then
      return true
    end
  end
  return false
end

-- only worth saving if at least one real file is open
local function has_file_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted and vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= "" then
      return true
    end
  end
  return false
end

function M.save()
  vim.fn.mkdir(M.dir, "p")
  vim.cmd("mksession! " .. vim.fn.fnameescape(session_file()))
end

function M.restore()
  local file = session_file()
  if vim.fn.filereadable(file) == 0 then
    vim.notify("No session for " .. vim.fn.getcwd(), vim.log.levels.WARN)
    return
  end
  vim.cmd("silent! %bwipeout!")
  vim.cmd("source " .. vim.fn.fnameescape(file))
end

-- auto-save on exit (like auto-session did), restore stays manual
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("opsi-sessions", {}),
  callback = function()
    if not is_suppressed() and has_file_buffers() then
      M.save()
    end
  end,
})

vim.keymap.set("n", "<leader>wr", M.restore, { desc = "[r]estore session for cwd" })

return M
