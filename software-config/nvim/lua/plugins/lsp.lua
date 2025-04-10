function detect_executable(name)
  return function() 
    return os.execute(string.format('which %s >/dev/null 2>&1', name)) == 0
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      rust_analyzer = {
        enable = detect_executable('rust-analyzer'),
      },
      tinymist = {
        enable = detect_executable('tinymist'),
      },
      nixd = {
        enable = detect_executable('nixd'),
      },
    },
    config = function (plugin, opts)
      local lspconfig = require("lspconfig")
      for server_name, config in pairs(opts) do
        if config.enable == nil or config.enable() then
          lspconfig[server_name].setup(config.settings or {})
        end
      end
    end
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "j-hui/fidget.nvim",
    opts = {},
  },
  {
    "nvimdev/lspsaga.nvim",
    opts = {},
  },
}
