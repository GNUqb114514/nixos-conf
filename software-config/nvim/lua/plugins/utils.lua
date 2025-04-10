return {
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {
      enable_check_bracket_line = true,
    },
  },
  {
    "s1n7ax/nvim-window-picker",
    config = function ()
      require('window-picker').setup {
        filter_rules = {
          bo = {
            filetype = { 'fidget' }
          }
        }
      }
      vim.keymap.set('n', "<leader>pw",
        function ()
          local window_number = require('window-picker').pick_window()
          if window_number then vim.api.nvim_set_current_win(window_number) end
        end
      )
    end
  },
  {
    'echasnovski/mini.ai',
    opts = {},
  },
  {
    'alohaia/fcitx.nvim',
    opts = {
      enable = {
        cmdtext = 'insert',
        select = 'insert',
      }
    },
    config = function (_, opts)
      require('fcitx')(opts)
    end
  },
}
