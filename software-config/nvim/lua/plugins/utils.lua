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
    keys = {
      { "<leader>pw", mode = 'n',
        function ()
          local window_number = require('window-picker').pick_window()
          if window_number then vim.api.nvim_set_current_win(window_number) end
        end
      },
    },
    main = 'window-picker',
    opts = {
      filter_rules = {
        bo = {
          filetype = { 'fidget' }
        }
      }
    }
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
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    keys = {},
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local set = vim.keymap.set

      -- Add or skip cursor above/below the main cursor.
      set({"n", "x"}, "<Leader>ck", function() mc.lineAddCursor(-1) end)
      set({"n", "x"}, "<Leader>cj", function() mc.lineAddCursor(1) end)
      set({"n", "x"}, "<leader>sk", function() mc.lineSkipCursor(-1) end)
      set({"n", "x"}, "<leader>sj", function() mc.lineSkipCursor(1) end)

      -- Add or skip adding a new cursor by matching word/selection
      set({"n", "x"}, "<leader>cn", function() mc.matchAddCursor(1) end)
      set({"n", "x"}, "<leader>sn", function() mc.matchSkipCursor(1) end)
      set({"n", "x"}, "<leader>cN", function() mc.matchAddCursor(-1) end)
      set({"n", "x"}, "<leader>sN", function() mc.matchSkipCursor(-1) end)

      -- Add and remove cursors with control + left click.
      set("n", "<c-leftmouse>", mc.handleMouse)
      set("n", "<c-leftdrag>", mc.handleMouseDrag)
      set("n", "<c-leftrelease>", mc.handleMouseRelease)

      -- Disable and enable cursors.
      set({"n", "x"}, "<c-q>", mc.toggleCursor)

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)

        -- Select a different cursor as the main one.
        layerSet({"n", "x"}, "<leader>hc", mc.prevCursor)
        layerSet({"n", "x"}, "<leader>lc", mc.nextCursor)

        -- Delete the main cursor.
        layerSet({"n", "x"}, "<leader>dc", mc.deleteCursor)

        -- Enable and clear cursors using escape.
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { link = "Cursor" })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn"})
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn"})
    end
  },
}
