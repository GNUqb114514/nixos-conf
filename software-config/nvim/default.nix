{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./general.nix
    ./ui.nix
    ./utils.nix
    ./languages.nix
    ./neogit.nix
    ./completion.nix
  ];

  programs.nvf.enable = true;
  programs.nvf.settings.vim = {
    # extraPlugins = {
    #   "vim-repeat" = {
    #     package = pkgs.vimPlugins.vim-repeat;
    #   };
    # };

    # languages.markdown.extensions.render-markdown-nvim = {
    #   enable = true;
    #   setupOpts = {
    #     heading.icons = {};
    #     bullet.icons = ["•" "∘" "⬥" "⬦"];
    #     completions.blink.enabled = true;
    #   };
    # };
  };
}
