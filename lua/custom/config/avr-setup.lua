local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- C/AVR formatting preferences
autocmd('FileType', {
  group = augroup('c_settings', { clear = true }),
  pattern = { 'c', 'h' },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    vim.opt_local.cindent = true
  end,
})

-- Format on save for C files
autocmd('BufWritePre', {
  group = augroup('c_format', { clear = true }),
  pattern = { '*.c', '*.h' },
  callback = function()
    vim.lsp.buf.format { async = false }
  end,
})
