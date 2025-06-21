{ pkgs, config, ... }: {
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  programs.nvf.settings.vim.highlight = {
    "Comment" = {
      fg = config.lib.stylix.colors.withHashtag.base04;
    };
    "TSComment" = {
      fg = config.lib.stylix.colors.withHashtag.base04;
      italic = true;
    };
  };

  imports = [ ./shared.nix ];
}
