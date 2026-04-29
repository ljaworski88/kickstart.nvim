-- lua/plugins/python-repl.lua
return {
  {
    'Vigemus/iron.nvim',
    config = function()
      local iron = require 'iron.core'

      iron.setup {
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {
              command = { 'ipython', '--no-autoindent' },
            },
          },
          repl_open_cmd = require('iron.view').bottom(15), -- 15 lines tall
        },
        keymaps = {
          send_motion = '<localleader>sc',
          visual_send = '<localleader>sc',
          send_file = '<localleader>sf',
          send_line = '<localleader>sl',
          send_paragraph = '<localleader>sp',
          send_until_cursor = '<localleader>su',
          send_mark = '<localleader>sm',
          mark_motion = '<localleader>mc',
          mark_visual = '<localleader>mc',
          remove_mark = '<localleader>md',
          cr = '<localleader>s<cr>',
          interrupt = '<localleader>s<space>',
          exit = '<localleader>sq',
          clear = '<localleader>cl',
        },
        highlight = { italic = true },
        ignore_blank_lines = true,
      }
    end,
  },
}
