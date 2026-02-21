{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.user.programming.typst;
in
{
  options.user.programming.typst = lib.mkEnableOption "Typst programming environment";

  config = lib.mkIf cfg {
    programs.nvf.settings.vim.languages = {
      typst.enable = true;
    };
  };
}
