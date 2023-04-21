local M = {}

local function default_on_open(term)
  vim.cmd("stopinsert")
  vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
end

function M.open_term(cmd, opts)
  opts = opts or {}
  opts.size = opts.size or vim.o.columns * 0.5
  opts.direction = opts.direction or "float"
  opts.on_open = opts.on_open or default_on_open
  opts.on_exit = opts.on_exit or nil

  local Terminal = require("toggleterm.terminal").Terminal
  local new_term = Terminal:new({
    cmd = cmd,
    dir = "git_dir",
    auto_scroll = false,
    close_on_exit = false,
    start_in_insert = false,
    on_open = opts.on_open,
    on_exit = opts.on_exit,
  })
  new_term:open(opts.size, opts.direction)
end

function M.quit()
  local bufnr = vim.api.nvim_get_current_buf()
  local buf_windows = vim.call("win_findbuf", bufnr)
  local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
  if modified and #buf_windows == 1 then
    vim.ui.input({
      prompt = "You have unsaved changes. Quit anyway? (y/n) ",
    }, function(input)
      if input == "y" then
        vim.cmd("qa!")
      end
    end)
  else
    vim.cmd("qa!")
  end
end

function M.find_files()
  local opts = {}
  local telescope = require("telescope.builtin")

  local ok = pcall(telescope.git_files, opts)
  if not ok then
    telescope.find_files(opts)
  end
end

function M.safe_require(plugin)
  local ok, result = pcall(require, plugin)
  if not ok then
    vim.notify(string.format("Plugin not installed: %s", plugin), vim.log.levels.WARN)
    return ok
  end
  return result
end

---@param plugin string
function M.has(plugin)
  local ok, _ = pcall(require, plugin)
  if not ok then
    return false
  end
  return true
end

return M
