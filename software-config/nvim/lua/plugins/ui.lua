return {
  {
    "https://github.com/folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function ()
        vim.cmd.colorscheme'tokyonight-storm'
    end
  },
  {   -- Status line: Start at starting UI
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    opts = {
      options = {
        disabled_filetypes = {
          'neo-tree',
          'sagaoutline',
        }
      }
    },
  },
  ---@type LazySpec
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
      -- check the installation instructions at
      -- https://github.com/folke/snacks.nvim
      "folke/snacks.nvim"
    },
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "<leader>ef",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        -- Open in the current working directory
        "<leader>ew",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "<leader>ee",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    ---@type YaziConfig | {}
    opts = {
      keymaps = {
        show_help = "<f1>",
      },
      highlight_groups = {
        -- See https://github.com/mikavilpas/yazi.nvim/pull/180
        hovered_buffer = nil,
        -- See https://github.com/mikavilpas/yazi.nvim/pull/351
        hovered_buffer_in_same_directory = nil,
      },
    },
  },
  {
    'akinsho/bufferline.nvim',
    opts = {},
  },
  {   -- Show lines for indents.
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>d",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>D",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      -- {
      --   "<leader>cs",
      --   "<cmd>Trouble symbols toggle focus=false<cr>",
      --   desc = "Symbols (Trouble)",
      -- },
      {
        "<leader>c",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      -- {
      --   "<leader>xL",
      --   "<cmd>Trouble loclist toggle<cr>",
      --   desc = "Location List (Trouble)",
      -- },
      -- {
      --   "<leader>xQ",
      --   "<cmd>Trouble qflist toggle<cr>",
      --   desc = "Quickfix List (Trouble)",
      -- },
    },
  },
  {
    'utilyre/barbecue.nvim',
    name = "barbecue",
    version = '*',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {},
  },
  {
    'utilyre/barbecue.nvim',
    name = "barbecue",
    version = '*',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {},
  },
  {
    'rcarriga/nvim-notify',
  }
}
