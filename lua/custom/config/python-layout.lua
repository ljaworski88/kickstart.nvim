-- Python IDE-like layout: bottom REPL + right variable viewer
local python_layout_group = vim.api.nvim_create_augroup('PythonLayout', { clear = true })

-- Track the variable viewer buffer
local varview_bufnr = nil

local function open_python_layout()
  -- Right split: variable viewer scratch buffer
  vim.cmd 'botright vsplit'
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_buf_set_name(buf, 'Variables')
  vim.bo[buf].filetype = 'python-varview'
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].swapfile = false
  vim.api.nvim_win_set_width(win, 40)
  varview_bufnr = buf

  -- Set header
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    '  Variables (IPython %whos)',
    string.rep('─', 38),
    '',
    '  <localleader>wh to refresh',
  })

  -- Return focus to original window
  vim.cmd 'wincmd h'

  -- Open iron REPL at bottom (iron handles the bottom split)
  vim.cmd 'IronRepl'
  vim.cmd 'wincmd k' -- jump back up to editor from REPL
end

-- Refresh variable viewer by sending %whos to iron and capturing output
local function refresh_varview()
  if varview_bufnr == nil or not vim.api.nvim_buf_is_valid(varview_bufnr) then
    vim.notify('Variable viewer not open', vim.log.levels.WARN)
    return
  end

  -- Send %whos to the REPL; user sees output in IPython terminal
  -- For a fancier capture you'd need a PTY trick — this sends the command
  require('iron.core').send(nil, '%whos\n')
  vim.notify('Sent %%whos to IPython — check REPL below', vim.log.levels.INFO)
end

vim.api.nvim_create_autocmd('FileType', {
  group = python_layout_group,
  pattern = 'python',
  callback = function()
    -- Only trigger once per session (skip if already laid out)
    if vim.fn.winnr '$' > 1 then
      return
    end
    open_python_layout()
  end,
})

-- Keymaps (localleader = \ by default in kickstart)
vim.api.nvim_create_autocmd('FileType', {
  group = python_layout_group,
  pattern = 'python',
  callback = function()
    local opts = { buffer = true, silent = true }
    -- Refresh variable viewer
    vim.keymap.set('n', '<localleader>wh', refresh_varview, opts)
    -- Toggle layout (re-open if closed)
    vim.keymap.set('n', '<localleader>wo', open_python_layout, opts)
  end,
})
