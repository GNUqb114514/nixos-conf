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
    programs.kitty.enable = true;
  };
}
