return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration

      -- Only one of these is needed.
      "nvim-telescope/telescope.nvim", -- optional
    },
    cmd = { "Neogit" },
  },
  {
    "sindrets/diffview.nvim",
    opts = {
      keymaps = {
        file_panel = {
          { "n", "q", "<cmd>tabclose<CR>", { desc = "Close diffview" } },
        },
      },
    },
  },
}
