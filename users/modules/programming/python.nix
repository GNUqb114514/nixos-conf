{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.user.programming.python;
in {
  options.user.programming.python = lib.mkEnableOption "Python programming environment";

  config = lib.mkIf cfg {
    home.packages = with pkgs; [
      python3
    ];

    programs.nvf.settings.vim.languages.python.enable = true;
  };
}
