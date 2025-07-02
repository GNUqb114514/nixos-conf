{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.user.programming.markdown;
in {
  options.user.programming.markdown = lib.mkEnableOption "Markdown editing environment";

  config = lib.mkIf cfg {
    programs.nvf.settings.vim.languages = {
      markdown.enable = true;
      markdown.format.enable = false;
      markdown.lsp.package = ["${pkgs.markdown-oxide}/bin/markdown-oxide"];
      markdown.extensions.markview-nvim = {
        enable = true;
        setupOpts = lib.mkMerge [
          (lib.mkIf config.user.terminal {
            markdown.list_items = {
              marker_minus.text = "•";
              marker_plus.text = "⬥";
              marker_star.text = "⬦";
            };
          })
        ];
      };
    };
  };
}
