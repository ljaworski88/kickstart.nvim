return {
  -- clangd extensions for switch header/source, memory usage etc
  {
    'p00f/clangd_extensions.nvim',
    lazy = true,
    ft = { 'c', 'h' },
    opts = {
      inlay_hints = {
        inline = true,
      },
    },
  },
}
