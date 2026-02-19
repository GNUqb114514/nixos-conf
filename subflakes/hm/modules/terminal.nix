{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.user.terminal;
in {
  options.user.terminal = lib.mkEnableOption "terminal (kitty)";

  config = lib.mkIf cfg {
    warnings = lib.optionals (!config.user.gui.enable) [ "Terminal should be with a GUI" ];
    programs.kitty.enable = true;
  };
}
