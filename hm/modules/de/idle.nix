{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.user.idle;
in
{
  options.user.idle = with lib; {
    enable = mkEnableOption "Stasis";
  };

  config.services.stasis = lib.mkIf cfg.enable {
    enable = true;
    extraConfig = builtins.readFile ./stasis.rune;
  };
}
