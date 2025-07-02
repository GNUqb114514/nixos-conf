{ pkgs, ... }: {
  programs.nvf.settings.vim = {
    lazy.plugins = {
      "neogit" = {
        package = pkgs.vimPlugins.neogit;
        cmd = ["Neogit"];
      };
      "diffview.nvim" = {
        package = pkgs.vimPlugins.diffview-nvim;
        setupOpts.keymaps.file_panel = [["n" "q" "<cmd>tabclose<CR>"]];
      };
    };
  };
}
