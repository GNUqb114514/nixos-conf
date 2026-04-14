{ lib, config, ... }:
let
  cfg = config.user.direnv;
in
{
  options.user.direnv = with lib; {
    enable = mkEnableOption "direnv";
  };

  config = lib.mkIf cfg.enable {
    programs.direnv.enable = true;
  };
}
