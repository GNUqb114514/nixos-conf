return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    highlight = { enable = true },
    ensure_installed = {
      "rust", "latex", "markdown", "markdown", "json", "lua", "regex", "toml", "xml", "yaml", "python"
    }
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end
}
