local function detect_executable(name)
  return function()
    return os.execute(string.format('which %s >/dev/null 2>&1', name)) == 0
  end
end

local function hint_in_ft(ft)
  return function()
    local augroup = vim.api.nvim_create_augroup("lsp.hint.unavailable", {
      clear = false,
    })
    vim.api.nvim_create_autocmd('BufEnter', {
      group = augroup,
      once = true,
      callback = function()
        if vim.bo.filetype == ft then
          require('notify').notify(
            "This file has corresponding LSP,\n" ..
            "but the LSP is not available in PATH,\n" ..
            "And this is probably not intended.\n" ..
            "You may try to use nix shell to temporarily enable it,\n" ..
            "or use nix develop if available.",
            vim.log.levels.ERROR, {
              title = "LSP Unavailable",
            })
        end
      end,
    })
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      rust_analyzer = {
        enable = detect_executable('rust-analyzer'),
        on_disabled = hint_in_ft("rust"),
      },
      tinymist = {
        enable = detect_executable('tinymist'),
        on_disabled = hint_in_ft("typst"),
      },
      nixd = {
        enable = detect_executable('nixd'),
        on_disabled = hint_in_ft("nix"),
      },
      lua_ls = {
        enable = detect_executable('lua-language-server'),
        on_disabled = hint_in_ft("lua"),
      },
    },
    config = function (_, opts)
      local lspconfig = require("lspconfig")
      for server_name, config in pairs(opts) do
        if config.enable == nil or config.enable() then
          lspconfig[server_name].setup(config.settings or {})
        elseif config.on_disabled ~= nil then
          config.on_disabled()
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
