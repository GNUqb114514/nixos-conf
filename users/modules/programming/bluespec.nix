{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.user.programming.bluespec;
in {
  options.user.programming.bluespec = lib.mkEnableOption "Bluespec programming environment";

  config = lib.mkIf cfg {
    home.packages = with pkgs; [
      bluespec
    ];
  };
}
