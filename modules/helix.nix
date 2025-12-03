{ lib, config, ... }: let
  cfg = config.user.helix;
in {
  options.user.helix = with lib; {
    enable = mkEnableOption "helix";
  };

  config = lib.mkIf cfg.enable {
    programs.helix.enable = true;
  };
}
